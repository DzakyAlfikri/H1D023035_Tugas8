import 'package:shared_preferences/shared_preferences.dart';

class UserInfo {
  Future setToken(String value) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString("token", value);
  }

  Future<String?> getToken() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    return pref.getString("token");
  }

  Future setUserID(int value) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setInt("userID", value);
  }

  Future<int?> getUserID() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getInt("userID");
  }

  Future logout() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
  }
  
  // Methods for local authentication
  Future setEmail(String value) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString("email", value);
  }

  Future<String?> getEmail() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("email");
  }

  Future setPassword(String value) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString("password", value);
  }

  Future<String?> getPassword() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("password");
  }
}