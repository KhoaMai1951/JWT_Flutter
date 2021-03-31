import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_login_test_2/constants/api_constant.dart';
import 'package:flutter_login_test_2/network_utils/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';
import 'login.dart';

class ConfirmEmail extends StatefulWidget {
  String email;
  ConfirmEmail({@required this.email});
  @override
  _ConfirmEmailState createState() => _ConfirmEmailState(email: this.email);
}

class _ConfirmEmailState extends State<ConfirmEmail> {
  String email;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  var verificationCode;

  _ConfirmEmailState({@required this.email});

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
                                  hintText: "Verification code",
                                  hintStyle: TextStyle(
                                      color: Color(0xFF9b9b9b),
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal),
                                ),
                                validator: (verificationCode) {
                                  if (verificationCode.isEmpty) {
                                    return 'Please enter verification code';
                                  }
                                  this.verificationCode = verificationCode;
                                  return null;
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: FlatButton(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 8, bottom: 8, left: 10, right: 10),
                                    child: Text(
                                      _isLoading ? 'Proccessing...' : 'Verify',
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
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var data = {
      'email': email,
      'activation_token': verificationCode,
    };

    var res = await Network().authData(data, kApiActivateAccount);
    var body = json.decode(res.body);
    // if activate success
    if (body['success']) {
      // SharedPreferences localStorage = await SharedPreferences.getInstance();
      // localStorage.setString('token', json.encode(body['token']));
      // localStorage.setString('user', json.encode(body['user']));
      Navigator.push(
        context,
        new MaterialPageRoute(
          builder: (context) => Login(),
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }
}
