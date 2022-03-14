import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/sheets/v4.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:youtube_reporter/core.dart';

class GoogleSignInService {
  factory GoogleSignInService() => _instance;
  GoogleSignInService._();
  static final _instance = GoogleSignInService._();

  late GoogleSignIn _googleSignIn;

  AuthClient? _client;
  AuthClient? get client => _client;

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  String get loggedInAs => _googleSignIn.currentUser!.email;

  Future<void> init() async {
    _googleSignIn = GoogleSignIn(
      clientId: AppEnv.googleApiKey,
      scopes: [
        'email',
        YouTubeApi.youtubeReadonlyScope,
        SheetsApi.spreadsheetsScope,
      ],
    );
  }

  Future<bool> login() async {
    try {
      await _googleSignIn.signIn();
    } catch (e, trace) {
      logError(e, trace);
      _isLoggedIn = false;
      return false;
    }

    final loggedIn = await _googleSignIn.isSignedIn();
    _isLoggedIn = loggedIn;

    if (!loggedIn) {
      return false;
    }

    _client = await _googleSignIn.authenticatedClient();

    if (client == null) {
      return false;
    }

    return true;
  }

  Future<bool> loginSilently() async {
    try {
      await _googleSignIn.signInSilently();
    } catch (e, trace) {
      logError(e, trace);
      _isLoggedIn = false;
      return false;
    }

    final loggedIn = await _googleSignIn.isSignedIn();
    _isLoggedIn = loggedIn;

    if (!loggedIn) {
      return false;
    }

    _client = await _googleSignIn.authenticatedClient();

    if (client == null) {
      return false;
    }

    return true;
  }
}
