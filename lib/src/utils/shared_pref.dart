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

  int? getInt(String key) => _prefs.getInt(key);
  Future<bool> setInt(String key, int value) => _prefs.setInt(key, value);
}
