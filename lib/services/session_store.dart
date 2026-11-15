import 'package:shared_preferences/shared_preferences.dart';

class SessionStore {
  const SessionStore(this._preferences);

  static const _usernameKey = 'loggedInUsername';
  static const _loggedInKey = 'isLoggedIn';

  final SharedPreferences _preferences;

  String? get username => _preferences.getString(_usernameKey);

  bool get isLoggedIn =>
      _preferences.getBool(_loggedInKey) == true && username != null;

  Future<void> saveLogin(String username) async {
    await _preferences.setString(_usernameKey, username);
    await _preferences.setBool(_loggedInKey, true);
  }

  Future<void> clearLogin() async {
    await _preferences.remove(_usernameKey);
    await _preferences.remove(_loggedInKey);
  }
}
