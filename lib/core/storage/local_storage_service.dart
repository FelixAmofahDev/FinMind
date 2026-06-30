import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  LocalStorageService(this._preferences);

  final SharedPreferences _preferences;

  static Future<LocalStorageService> create() async {
    final preferences = await SharedPreferences.getInstance();
    return LocalStorageService(preferences);
  }

  Future<bool> setString(String key, String value) => _preferences.setString(key, value);

  String? getString(String key) => _preferences.getString(key);

  Future<bool> setBool(String key, bool value) => _preferences.setBool(key, value);

  bool? getBool(String key) => _preferences.getBool(key);

  Future<bool> setInt(String key, int value) => _preferences.setInt(key, value);

  int? getInt(String key) => _preferences.getInt(key);

  Future<bool> remove(String key) => _preferences.remove(key);

  Future<bool> clear() => _preferences.clear();
}
