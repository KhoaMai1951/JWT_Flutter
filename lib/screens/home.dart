import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_login_test_2/helpers/upload_image.dart';
import 'package:flutter_login_test_2/network_utils/api.dart';
import 'package:flutter_login_test_2/screens/submit_post.dart';
import 'package:flutter_login_test_2/screens/upload_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String name;
  @override
  void initState() {
    _loadUserData();
    super.initState();
  }

  _loadUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user'));
    if (user != null) {
      setState(() {
        name = user['name'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test App'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Hi, $name',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Center(
              child: RaisedButton(
                elevation: 10,
                onPressed: () {
                  logout();
                },
                color: Colors.teal,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Text('Logout'),
              ),
            ),
            Center(
              child: RaisedButton(
                elevation: 10,
                onPressed: () {
                  submitPostScreen();
                },
                color: Colors.lightBlue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Text('Submit Post'),
              ),
            ),
            Center(
              child: RaisedButton(
                elevation: 10,
                onPressed: () {
                  uploadImageScreen();
                },
                color: Colors.yellowAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Text('Upload Image'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void logout() async {
    var res = await Network().getData('/logout');
    var body = json.decode(res.body);
    if (body['success']) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.remove('user');
      localStorage.remove('token');
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    }
  }

  void submitPostScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubmitPost(),
      ),
    );
  }

  void uploadImageScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UploadImage(),
      ),
    );
  }
}
