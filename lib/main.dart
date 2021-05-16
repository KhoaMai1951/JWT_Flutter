import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_login_test_2/screens/discover/discover.dart';
import 'package:flutter_login_test_2/screens/loading/loading_main.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test App',
      debugShowCheckedModeBanner: false,
      home: CheckAuth(),
    );
  }
}

class CheckAuth extends StatefulWidget {
  @override
  _CheckAuthState createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  bool isAuth = false;
  @override
  void initState() {
    //_checkIfLoggedIn();
    super.initState();
  }

  // void _checkIfLoggedIn() async {
  //   SharedPreferences localStorage = await SharedPreferences.getInstance();
  //   var token = localStorage.getString('token');
  //
  //   //if there is token
  //   if (token != null) {
  //     // check if token is still valid
  //     var response = await Network().getData(kApiGetDataWithToken);
  //     // token still valid
  //     if (response.statusCode == 200) {
  //       setState(() {
  //         isAuth = true;
  //       });
  //     }
  //     // token invalid
  //     else {
  //       localStorage.remove('token');
  //       setState(() {
  //         isAuth = false;
  //       });
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // Widget child;
    // if (isAuth) {
    //   child = Home();
    // } else {
    //   child = Login();
    // }
    // return Scaffold(
    //   body: child,
    // );

    return LoadingScreen();
    //return DiscoverScreen();
  }
}
