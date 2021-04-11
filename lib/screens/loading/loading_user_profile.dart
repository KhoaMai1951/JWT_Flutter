import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_test_2/models/user_model.dart';
import 'package:flutter_login_test_2/network_utils/api.dart';
import 'package:flutter_login_test_2/screens/profile.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadingProfileScreen extends StatefulWidget {
  @override
  _LoadingProfileScreenState createState() => _LoadingProfileScreenState();
}

class _LoadingProfileScreenState extends State<LoadingProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitRing(
          color: Colors.teal,
          lineWidth: 3.0,
          size: 40.0,
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUser();
  }

  fetchUser() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user'));
    var userId = user['id'];

    var res = await Network().getData('/user/get_user_info_by_id?id=$userId');
    var body = json.decode(res.body);

    // user model
    int id = body['user'][0]['id'];
    String username = body['user'][0]['username'];
    String name = body['user'][0]['name'];
    String email = body['user'][0]['email'];
    String bio = body['user'][0]['bio'];
    String avatarUrl = body['avatar_link'][0]['url'];
    int numberOfFollowers = body['number_of_followers'];
    int numberOfFollowing = body['number_of_following'];

    UserModel userModel = new UserModel(
      id: id,
      username: username,
      name: name,
      email: email,
      bio: bio,
      avatarUrl: avatarUrl,
      followersNumber: numberOfFollowers,
      followingNumber: numberOfFollowing,
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return ProfileScreen(
          user: userModel,
        );
      }),
    );
  }
}
