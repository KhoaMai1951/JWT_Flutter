import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_login_test_2/constants/api_constant.dart';
import 'package:flutter_login_test_2/constants/bottom_bar_index_constant.dart';
import 'package:flutter_login_test_2/network_utils/api.dart';
import 'package:flutter_login_test_2/screens/testing/comment_infinite_list_view.dart';
import 'package:flutter_login_test_2/screens/upload_image.dart';
import 'package:flutter_login_test_2/services/TagService.dart';
import 'package:flutter_login_test_2/widgets/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'loading/loading_test.dart';
import 'submit_post.dart';
import 'login.dart';

class Home extends StatefulWidget {
  static const String id = 'test_screen';

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

  void _onItemTapped(int index) {
    switch (index) {
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UploadImage(),
          ),
        );
        break;
      case 2:
        Navigator.pushNamed(context, '/second');
        break;
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
                onPressed: () async {
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
            Center(
              child: RaisedButton(
                elevation: 10,
                onPressed: () {
                  uploadImageScreen();
                },
                color: Colors.orange,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Text('Profile'),
              ),
            ),
            Center(
              child: RaisedButton(
                elevation: 10,
                onPressed: () {
                  loadingScreenTest();
                },
                color: Colors.grey,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Text('Test Loading template'),
              ),
            ),
            Center(
              child: RaisedButton(
                elevation: 10,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CommentInfinite(),
                    ),
                  );
                },
                color: Colors.lightGreen,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Text('Test infinite comment'),
              ),
            ),
            Container(
              child: 1 == 2
                  ? SpinKitThreeBounce(
                      color: Colors.grey,
                      size: 30.0,
                    )
                  : null,
            )
          ],
        ),
      ),
      bottomNavigationBar: buildBottomNavigationBar(
          context: context, index: kBottomBarIndexTest),
    );
  }

  void logout() async {
    var res = await Network().getData(kApiLogout);
    var body = json.decode(res.body);
    //print(body);
    if (body['success']) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.remove('user');
      localStorage.remove('token');
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    }
  }

  Future<void> submitPostScreen() async {
    // var plantTagList = await TagService.getTagsByTypeId(1);
    // var contentTagList = await TagService.getTagsByTypeId(2);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubmitPostScreen(
            // plantTagList: plantTagList,
            // contentTagList: contentTagList,
            ),
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

  void profileScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UploadImage(),
      ),
    );
  }

  void loadingScreenTest() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoadingTest(),
      ),
    );
  }
}
