import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_login_test_2/constants/api_constant.dart';
import 'package:flutter_login_test_2/network_utils/api.dart';
import 'package:flutter_login_test_2/screens/authentication/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountManage {
  static void logout({var context}) async {
    var res = await Network().getData(kApiLogout);
    var body = json.decode(res.body);

    if (body['success']) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.remove('user');
      localStorage.remove('token');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Login(),
        ),
      );
    } else
      print('fail');
  }
}
