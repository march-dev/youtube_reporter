import 'package:firebase_core/firebase_core.dart';
import 'package:youtube_reporter/core.dart';

class FirInitializer {
  const FirInitializer._();

  static Future<void> init() async {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        appId: AppEnv.firAppId,
        apiKey: AppEnv.firApiKey,
        messagingSenderId: AppEnv.firMessagingSenderId,
        projectId: 'socialreporter',
      ),
    );
  }
}
