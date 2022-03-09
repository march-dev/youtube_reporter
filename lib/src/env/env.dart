class AppEnv {
  const AppEnv._();

  static const googleApiKey = String.fromEnvironment('google_api_key');

  static const tdApiId = int.fromEnvironment('td_api_id');
  static const tdApiHash = String.fromEnvironment('td_api_hash');

  static const firAppId = String.fromEnvironment('fir_app_id');
  static const firApiKey = String.fromEnvironment('fir_api_key');
  static const firMeasurementId = String.fromEnvironment('fir_measurement_id');
  static const firMessagingSenderId =
      String.fromEnvironment('fir_messaging_sender_id');
}
