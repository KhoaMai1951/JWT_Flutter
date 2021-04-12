import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_test_2/constants/api_constant.dart';
import 'package:flutter_login_test_2/network_utils/api.dart';
import 'package:flutter_login_test_2/screens/home.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../login.dart';

class LoadingScreen extends StatefulWidget {
  static const String id = 'loading_main_screen';
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkIfLoggedIn();
  }

  void _checkIfLoggedIn() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');

    //if there is token
    if (token != null) {
      print('there is token');
      // check if token is still valid
      var response = await Network().getData(kApiGetDataWithToken);
      // token still valid
      if (response.statusCode == 200) {
        print('token valid');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return Home();
          }),
        );
      }
      // token invalid
      else {
        localStorage.remove('token');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return Login();
          }),
        );
      }
    }
    //if there isn't any token
    else {
      print('doesnt have token');
      // pop trang loading ra khỏi stack
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return Login();
        }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              height: 50.0,
              child: Image.asset('images/logo.png'),
            ),
          ),
          SizedBox(
            height: 60.0,
          ),
          SpinKitRing(
            color: Colors.teal,
            lineWidth: 3.0,
            size: 40.0,
          ),
        ],
      ),
    );
  }
}
