import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class UserGlobal {
  static var user;
  static var test;
  static var test2;

  static fetchUserFromLocal() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    UserGlobal.user = jsonDecode(localStorage.getString('user'));
  }
}
