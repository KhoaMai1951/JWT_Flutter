import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_test_2/models/user_model.dart';
import 'package:flutter_login_test_2/network_utils/api.dart';
import 'package:flutter_login_test_2/screens/account/profile.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadingProfileScreen extends StatefulWidget {
  int userId;
  LoadingProfileScreen({Key key, @required this.userId}) : super(key: key);
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
    // NẾU LÀ CHỦ TÀI KHOẢN
    if (widget.userId == -1) {
      // lấy user id từ trong điện thoại
      widget.userId = user['id'];
    }

    var idToSend = widget.userId;
    var res = await Network().getData('/user/get_user_info_by_id?id=$idToSend');
    var body = json.decode(res.body);

    // user model
    int id = body['user'][0]['id'];
    String username = body['user'][0]['username'];
    String name = body['user'][0]['name'];
    String email = body['user'][0]['email'];
    String bio = body['user'][0]['bio'];
    String avatarUrl = body['avatar_link'];
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
    // pop trang loading ra khỏi stack
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return ProfileScreen(
          user: userModel,
          currentUserId: user['id'],
        );
      }),
    );
  }
}
