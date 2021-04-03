import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_login_test_2/constants/api_constant.dart';
import 'package:flutter_login_test_2/network_utils/api.dart';
import 'package:flutter_login_test_2/screens/confirm_email.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';
import 'login.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  var email;
  var password;
  var confirmPassword;
  var username;
  var name;
  String emailValidator;
  String nameValidator;
  String usernameValidator;
  String passwordValidator;
  String confirmPasswordValidator;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.teal,
        child: Stack(
          children: <Widget>[
            Positioned(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Card(
                      elevation: 4.0,
                      color: Colors.white,
                      margin: EdgeInsets.only(left: 20, right: 20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              TextFormField(
                                style: TextStyle(color: Color(0xFF000000)),
                                cursorColor: Color(0xFF9b9b9b),
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: Colors.grey,
                                  ),
                                  hintText: "Email",
                                  hintStyle: TextStyle(
                                      color: Color(0xFF9b9b9b),
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal),
                                ),
                                validator: (emailValue) {
                                  email = emailValue;
                                  return null;
                                },
                              ),
                              Align(
                                child: Text(
                                  emailValidator != null ? emailValidator : '',
                                  style: TextStyle(
                                      color: Colors.red[800], fontSize: 12.0),
                                ),
                                alignment: Alignment.topLeft,
                              ),
                              TextFormField(
                                style: TextStyle(color: Color(0xFF000000)),
                                cursorColor: Color(0xFF9b9b9b),
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.insert_emoticon,
                                    color: Colors.grey,
                                  ),
                                  hintText: "Tên",
                                  hintStyle: TextStyle(
                                      color: Color(0xFF9b9b9b),
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal),
                                ),
                                validator: (name) {
                                  this.name = name;
                                  return null;
                                },
                              ),
                              Align(
                                child: Text(
                                  nameValidator != null ? nameValidator : '',
                                  style: TextStyle(
                                      color: Colors.red[800], fontSize: 12.0),
                                ),
                                alignment: Alignment.topLeft,
                              ),
                              TextFormField(
                                style: TextStyle(color: Color(0xFF000000)),
                                cursorColor: Color(0xFF9b9b9b),
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.insert_emoticon,
                                    color: Colors.grey,
                                  ),
                                  hintText: "Tên người dùng",
                                  hintStyle: TextStyle(
                                      color: Color(0xFF9b9b9b),
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal),
                                ),
                                validator: (username) {
                                  this.username = username;
                                  return null;
                                },
                              ),
                              Align(
                                child: Text(
                                  usernameValidator != null
                                      ? usernameValidator
                                      : '',
                                  style: TextStyle(
                                      color: Colors.red[800], fontSize: 12.0),
                                ),
                                alignment: Alignment.topLeft,
                              ),
                              TextFormField(
                                style: TextStyle(color: Color(0xFF000000)),
                                cursorColor: Color(0xFF9b9b9b),
                                keyboardType: TextInputType.text,
                                obscureText: true,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.vpn_key,
                                    color: Colors.grey,
                                  ),
                                  hintText: "Mật khẩu",
                                  hintStyle: TextStyle(
                                      color: Color(0xFF9b9b9b),
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal),
                                ),
                                validator: (passwordValue) {
                                  password = passwordValue;
                                  return null;
                                },
                              ),
                              Align(
                                child: Text(
                                  passwordValidator != null
                                      ? passwordValidator
                                      : '',
                                  style: TextStyle(
                                      color: Colors.red[800], fontSize: 12.0),
                                ),
                                alignment: Alignment.topLeft,
                              ),
                              TextFormField(
                                style: TextStyle(color: Color(0xFF000000)),
                                cursorColor: Color(0xFF9b9b9b),
                                keyboardType: TextInputType.text,
                                obscureText: true,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.vpn_key,
                                    color: Colors.grey,
                                  ),
                                  hintText: "Xác nhận mật khẩu",
                                  hintStyle: TextStyle(
                                      color: Color(0xFF9b9b9b),
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal),
                                ),
                                validator: (confirmPasswordValue) {
                                  confirmPassword = confirmPasswordValue;
                                  return null;
                                },
                              ),
                              Align(
                                child: Text(
                                  confirmPasswordValidator != null
                                      ? confirmPasswordValidator
                                      : '',
                                  style: TextStyle(
                                      color: Colors.red[800], fontSize: 12.0),
                                ),
                                alignment: Alignment.topLeft,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: FlatButton(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 8, bottom: 8, left: 10, right: 10),
                                    child: Text(
                                      _isLoading ? 'Đang xử lý...' : 'Đăng ký',
                                      textDirection: TextDirection.ltr,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.0,
                                        decoration: TextDecoration.none,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  color: Colors.teal,
                                  disabledColor: Colors.grey,
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(20.0)),
                                  onPressed: () {
                                    setState(() {
                                      this.emailValidator = null;
                                      this.nameValidator = null;
                                      this.usernameValidator = null;
                                      this.passwordValidator = null;
                                      this.confirmPasswordValidator = null;
                                    });
                                    if (_formKey.currentState.validate()) {
                                      _register();
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => Login()));
                        },
                        child: Text(
                          'Đã có tài khoản',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _register() async {
    setState(() {
      _isLoading = true;
    });
    var data = {
      'username': username,
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': confirmPassword,
    };

    var res = await Network().authData(data, kApiRegister);
    var body = json.decode(res.body);
    if (body['success']) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();

      Navigator.push(
        context,
        new MaterialPageRoute(
          builder: (context) => ConfirmEmail(
            email: this.email,
          ),
        ),
      );
    } else {}

    setState(() {
      _isLoading = false;
      // email validate
      body['message']['email'] != null
          ? this.emailValidator = body['message']['email'].toString()
          : '';
      // name validate
      body['message']['name'] != null
          ? this.nameValidator = body['message']['name'].toString()
          : '';

      // username validate
      body['message']['username'] != null
          ? this.usernameValidator = body['message']['username'].toString()
          : '';

      // password validate
      body['message']['password'] != null
          ? this.passwordValidator = body['message']['password'].toString()
          : '';

      // confirm password validate
      body['message']['confirm_password'] != null
          ? this.confirmPasswordValidator =
              body['message']['confirm_password'].toString()
          : '';
    });
  }

  _showMsg(msg) {
    // final snackBar = SnackBar(
    //   content: Text(msg),
    //   action: SnackBarAction(
    //     label: 'Close',
    //     onPressed: () {
    //       // Some code to undo the change!
    //     },
    //   ),
    // );
    // _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
