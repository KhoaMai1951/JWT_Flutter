import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_login_test_2/constants/bottom_bar_index_constant.dart';
import 'package:flutter_login_test_2/constants/color_constant.dart';
import 'package:flutter_login_test_2/globals/user_global.dart';
import 'package:flutter_login_test_2/network_utils/api.dart';
import 'package:flutter_login_test_2/screens/loading/loading_user_profile.dart';
import 'package:flutter_login_test_2/widgets/bottom_navigation_bar/bottom_navigation_bar.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  String password;
  String confirmPassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kBottomBarColor,
        title: Text('Đổi mật khẩu'),
      ),
      body: bodyLayout(),
      bottomNavigationBar: buildBottomNavigationBar(
          context: context, index: kBottomBarIndexProfile),
    );
  }

  bodyLayout() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // FORM
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // TITLE USERNAME
                  Row(
                    children: [
                      Text('Mật khẩu mới'),
                    ],
                  ),
                  // PASSWORD
                  TextFormField(
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Không được bỏ trống';
                      }
                      if (value.length < 4) {
                        return 'Mật khẩu phải lớn hơn 4 kí tự';
                      }
                      setState(() {
                        this.password = value;
                      });
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  // TITLE CONFIRM PASSWORD
                  Row(
                    children: [
                      Text('Xác nhận mật khẩu mới'),
                    ],
                  ),
                  // CONFIRM PASSWORD
                  TextFormField(
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Không được bỏ trống';
                      }
                      if (value != this.password) {
                        return 'Không trùng mật khẩu';
                      }
                      setState(() {
                        this.confirmPassword = value;
                      });
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 40.0,
          ),
          // BUTTON
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(kButtonColor),
            ),
            onPressed: () {
              // Validate returns true if the form is valid, or false otherwise.
              if (_formKey.currentState.validate() == true) {
                // If the form is valid, display a snackbar.
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Đang xử lý'),
                    duration: const Duration(seconds: 1),
                  ),
                );
                submitForm();
              }
            },
            child: Text('Đổi mật khẩu'),
          ),
        ],
      ),
    );
  }

  submitForm() async {
    var data = {
      'password': password,
      'password_confirmation': confirmPassword,
      'email': UserGlobal.user['email'],
    };

    var res = await Network().postData(data, '/user/change_password');
    var body = json.decode(res.body);
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoadingProfileScreen(userId: -1),
      ),
    );
  }
}
