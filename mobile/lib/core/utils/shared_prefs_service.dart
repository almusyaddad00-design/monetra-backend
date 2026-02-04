import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  static const String keyToken = 'auth_token';
  static const String keyUser = 'user_data';
  static const String keyLastSync = 'last_sync_time';

  final SharedPreferences _prefs;

  SharedPrefsService(this._prefs);

  Future<void> saveToken(String token) async {
    await _prefs.setString(keyToken, token);
  }

  String? getToken() {
    return _prefs.getString(keyToken);
  }

  Future<void> removeToken() async {
    await _prefs.remove(keyToken);
  }

  Future<void> saveLastSyncTime(String timestamp) async {
    await _prefs.setString(keyLastSync, timestamp);
  }

  String? getLastSyncTime() {
    return _prefs.getString(keyLastSync);
  }

  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
