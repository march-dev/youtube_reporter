import 'dart:async';

import 'package:tdlib/td_api.dart';

import 'client.dart';

typedef ErrorCallback = void Function(TdError error);
typedef ResultCallback = Future<TdObject<dynamic>?> Function();

enum TdAuthStatus {
  waitingOtp,
  ready,
  error,
}

class TelegramService {
  factory TelegramService() => _instance;
  TelegramService._();
  static final _instance = TelegramService._();

  late TelegramClient _client;
  late String _appDocDir;
  late String _appExtDir;

  var _statusCompleter = Completer<TdAuthStatus>();
  late StreamSubscription<TdObject> _eventSub;

  bool _initialized = false;

  void init(TelegramClient client) {
    if (_initialized) {
      dispose();
    }

    _initialized = true;

    _client = client;

    _appDocDir = '';
    _appExtDir = '';

    _eventSub = _client.events.listen(_onEvent);

    _setTdlibParameters();
  }

  void dispose() {
    _eventSub.cancel();
  }

  // !
  // ! Event section
  // !
  Future<void> _onEvent(TdObject event) async {
    switch (event.getConstructor()) {
      case UpdateAuthorizationState.CONSTRUCTOR:
        await _handleAuth(
          (event as UpdateAuthorizationState).authorizationState,
          isOffline: true,
        );
        break;

      default:
        return;
    }
  }

  Future<void> _handleAuth(
    AuthorizationState authState, {
    bool isOffline = false,
  }) async {
    switch (authState.getConstructor()) {
      case AuthorizationStateWaitTdlibParameters.CONSTRUCTOR:
        _setTdlibParameters();
        return;
      case AuthorizationStateWaitEncryptionKey.CONSTRUCTOR:
        if ((authState as AuthorizationStateWaitEncryptionKey).isEncrypted) {
          await _client.send(
            const CheckDatabaseEncryptionKey(
              encryptionKey: 'mostrandomencryption',
            ),
          );
        } else {
          await _client.send(
            const SetDatabaseEncryptionKey(
              newEncryptionKey: 'mostrandomencryption',
            ),
          );
        }
        return;
      case AuthorizationStateWaitCode.CONSTRUCTOR:
        _statusCompleter.complete(TdAuthStatus.waitingOtp);
        break;
      case AuthorizationStateReady.CONSTRUCTOR:
      case AuthorizationStateWaitPassword.CONSTRUCTOR:
        _statusCompleter.complete(TdAuthStatus.ready);
        break;
      case AuthorizationStateClosed.CONSTRUCTOR:
      case AuthorizationStateWaitPhoneNumber.CONSTRUCTOR:
      case AuthorizationStateWaitOtherDeviceConfirmation.CONSTRUCTOR:
      case AuthorizationStateWaitRegistration.CONSTRUCTOR:
      case AuthorizationStateLoggingOut.CONSTRUCTOR:
      case AuthorizationStateClosing.CONSTRUCTOR:
        return;
      default:
        return;
    }
  }

  // !
  // ! Method section
  // !
  Future<TdAuthStatus> _methodWrapper(
    ResultCallback action,
    ErrorCallback onError,
  ) async {
    _statusCompleter = Completer();
    final result = await action();

    if (result != null && result is Ok) {
      return _statusCompleter.future;
    }

    if (result != null && result is TdError) {
      onError(result);
    }

    return TdAuthStatus.error;
  }

  Future<void> _setTdlibParameters() async {
    await _client.send(
      SetTdlibParameters(
        parameters: TdlibParameters(
          useTestDc: true,
          useSecretChats: false,
          useMessageDatabase: true,
          useFileDatabase: true,
          useChatInfoDatabase: true,
          ignoreFileNames: true,
          enableStorageOptimizer: true,
          systemLanguageCode: 'EN',
          filesDirectory: _appExtDir,
          databaseDirectory: _appDocDir,
          applicationVersion: '0.0.1',
          deviceModel: 'Unknown',
          systemVersion: 'Unknonw',
          
        ),
      ),
    );
  }

  Future<TdAuthStatus> login(
    String phoneNumber, {
    required ErrorCallback onError,
  }) {
    return _methodWrapper(
      () => _client.send(
        SetAuthenticationPhoneNumber(
          phoneNumber: phoneNumber,
          settings: const PhoneNumberAuthenticationSettings(
            allowFlashCall: false,
            isCurrentPhoneNumber: false,
            allowSmsRetrieverApi: false,
            allowMissedCall: true,
            authenticationTokens: [],
          ),
        ),
      ),
      onError,
    );
  }

  Future<TdAuthStatus> checkOtp(
    String code, {
    required ErrorCallback onError,
  }) {
    return _methodWrapper(
      () => _client.send(
        CheckAuthenticationCode(
          code: code,
        ),
      ),
      onError,
    );
  }
}
