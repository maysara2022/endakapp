import 'package:shared_preferences/shared_preferences.dart';

class UserPrefs {
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userToken', token);
  }
  static Future<void> saveId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
  }


  static Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userToken') ?? '';
  }
  static Future<int> getId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId') ?? 0;
  }


  static Future<void> clearData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userToken');
    await prefs.remove('userId');

  }


}
