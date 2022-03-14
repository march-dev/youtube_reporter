import 'package:package_info_plus/package_info_plus.dart';

class AppEnv {
  const AppEnv._();

  static Future<void> init() async {
    final info = await PackageInfo.fromPlatform();
    appVersion = '${info.version}+${info.buildNumber}';
  }

  static late final String appVersion;

  static const googleApiKey = String.fromEnvironment('google_api_key');

  static const firAppId = String.fromEnvironment('fir_app_id');
  static const firApiKey = String.fromEnvironment('fir_api_key');
  static const firMessagingSenderId =
      String.fromEnvironment('fir_messaging_sender_id');

  static const sheetId = String.fromEnvironment('sheet_id');
}
