import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  factory SharedPref() => _instance;
  SharedPref._();
  static final _instance = SharedPref._();

  static late final SharedPreferences _prefs;
  static bool _initialized = false;

  Future<void> init() async {
    if (_initialized) {
      return;
    }
    _initialized = true;
    _prefs = await SharedPreferences.getInstance();
  }

  String? getString(String key) => _prefs.getString(key);
  Future<bool> setString(String key, String value) =>
      _prefs.setString(key, value);
}
