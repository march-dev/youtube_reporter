class AppEnv {
  const AppEnv._();

  static const googleApiKey = String.fromEnvironment('google_api_key');
  static const tdApiId = int.fromEnvironment('td_api_id');
  static const tdApiHash = String.fromEnvironment('td_api_hash');
}
