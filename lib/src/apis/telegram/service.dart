import 'dart:async';

import 'package:tdlib/td_api.dart';

import 'client.dart';

typedef ErrorCallback = void Function(TdError error);
typedef ResultCallback = Future<TdObject<dynamic>?> Function();

enum TdAuthStatus {
  waitingPhoneOrClosed,
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

  late StreamController<TdAuthStatus> _statusController;
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
  }

  void dispose() {
    _statusController.close();
    _eventSub.cancel();
  }

  // !
  // ! Event section
  // !
  Future<void> _onEvent(TdObject event) async {
    try {
      print('_onEvent =>>>> ${event.toJson()}');
    } catch (e) {
      print('_onEvent =>>>> ${event.getConstructor()}');
    }

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
        await _client.send(
          SetTdlibParameters(
            parameters: TdlibParameters(
              useTestDc: false,
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
              apiId: 1311145,
              apiHash: '634c7b54b8b710ad6a36428b095e2b60',
            ),
          ),
        );
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
      case AuthorizationStateClosed.CONSTRUCTOR:
      case AuthorizationStateWaitPhoneNumber.CONSTRUCTOR:
        _statusController.add(TdAuthStatus.waitingPhoneOrClosed);
        break;
      case AuthorizationStateWaitCode.CONSTRUCTOR:
        _statusController.add(TdAuthStatus.waitingOtp);
        break;
      case AuthorizationStateReady.CONSTRUCTOR:
        _statusController.add(TdAuthStatus.ready);
        break;
      case AuthorizationStateWaitOtherDeviceConfirmation.CONSTRUCTOR:
      case AuthorizationStateWaitRegistration.CONSTRUCTOR:
      case AuthorizationStateWaitPassword.CONSTRUCTOR:
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
    final result = await action();

    if (result != null && result is TdError) {
      onError(result);
      _statusController.add(TdAuthStatus.error);
    }

    return _statusController.stream.first;
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
