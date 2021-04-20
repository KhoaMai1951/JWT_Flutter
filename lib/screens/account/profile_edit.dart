import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_login_test_2/constants/bottom_bar_index_constant.dart';
import 'package:flutter_login_test_2/constants/color_constant.dart';
import 'package:flutter_login_test_2/models/user_model.dart';
import 'package:flutter_login_test_2/network_utils/api.dart';
import 'package:flutter_login_test_2/screens/loading/loading_user_profile.dart';
import 'package:flutter_login_test_2/widgets/bottom_navigation_bar/bottom_navigation_bar.dart';

class ProfileEditScreen extends StatefulWidget {
  ProfileEditScreen({Key key, this.userModel}) : super(key: key);
  UserModel userModel;
  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  String username;
  String name;
  String bio;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kBottomBarColor,
        title: Text('Chỉnh sửa thông tin'),
      ),
      body: bodyLayout(),
      bottomNavigationBar: buildBottomNavigationBar(
          context: context, index: kBottomBarIndexProfile),
    );
  }

  bodyLayout() {
    return ListView(
      children: [
        Container(
          child: Column(
            children: [
              // FORM
              Container(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      // TITLE USERNAME
                      Row(
                        children: [
                          Text('Tên người dùng'),
                        ],
                      ),
                      // USERNAME
                      TextFormField(
                        initialValue: widget.userModel.username,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Không được bỏ trống';
                          }
                          if (value.length > 50) {
                            return 'Tên người dùng phải nhỏ hơn 50 kí tự';
                          }
                          setState(() {
                            this.username = value;
                          });
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      // TITLE NAME
                      Row(
                        children: [
                          Text('Tên'),
                        ],
                      ),
                      // NAME
                      TextFormField(
                        initialValue: widget.userModel.name,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Không được bỏ trống';
                          }
                          if (value.length > 50) {
                            return 'Tên người dùng phải nhỏ hơn 50 kí tự';
                          }
                          setState(() {
                            this.name = value;
                          });
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      // TITLE BIO
                      Row(
                        children: [
                          Text('Bio'),
                        ],
                      ),
                      // NAME
                      TextFormField(
                        maxLines: 5,
                        initialValue: widget.userModel.bio,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Không được bỏ trống';
                          }
                          if (value.length > 1000) {
                            return ' Bio phải nhỏ hơn 1000 kí tự';
                          }
                          setState(() {
                            this.bio = value;
                          });
                          return null;
                        },
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
                  backgroundColor:
                      MaterialStateProperty.all<Color>(kButtonColor),
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
                child: Text('Thay đổi'),
              ),
            ],
          ),
        )
      ],
    );
  }

  submitForm() async {
    var data = {
      'user_id': widget.userModel.id,
      'username': username,
      'name': name,
      'bio': bio,
    };

    var res = await Network().postData(data, '/user/update_info');
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
