import 'package:shared_preferences/shared_preferences.dart';

class Saver {
  void setLoginStatus(bool value) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    _preferences.setBool("loginState", value);
  }
}
