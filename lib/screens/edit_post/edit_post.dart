import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_test_2/constants/bottom_bar_index_constant.dart';
import 'package:flutter_login_test_2/constants/color_constant.dart';
import 'package:flutter_login_test_2/models/post_detail_model.dart';
import 'package:flutter_login_test_2/network_utils/api.dart';
import 'package:flutter_login_test_2/screens/loading/loading_post_detail.dart';
import 'package:flutter_login_test_2/widgets/bottom_navigation_bar/bottom_navigation_bar.dart';

class EditPostScreen extends StatefulWidget {
  EditPostScreen({Key key, this.postId}) : super(key: key);
  var postId;
  @override
  _EditPostScreenState createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  var title;
  var content;
  PostDetailModel postDetailModel;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchPost();
  }

  fetchPost() async {
    var data = {'id': widget.postId};
    var response = await Network().postData(data, '/post/get_post');
    var body = json.decode(response.body);

    if (response.statusCode == 200) {
      PostDetailModel postDetailModelTemp = new PostDetailModel(
        content: body['post']['content'],
        title: body['post']['title'],
      );
      setState(() {
        postDetailModel = postDetailModelTemp;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: UniqueKey(),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Chỉnh sửa bài viết',
        ),
        backgroundColor: kAppBarColor,
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
                      // TITLE POST TITLE
                      Row(
                        children: [
                          Text('Tiêu đề'),
                        ],
                      ),
                      // POST TITLE
                      TextFormField(
                        key: UniqueKey(),
                        initialValue: this.postDetailModel != null
                            ? postDetailModel.title
                            : 'đang tải...',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Không được bỏ trống';
                          }
                          if (value.length > 100) {
                            return 'Tiêu đề phải nhỏ hơn 100 kí tự';
                          }
                          setState(() {
                            this.title = value;
                          });
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      // TITLE POST CONTENT
                      Row(
                        children: [
                          Text('Nội dung'),
                        ],
                      ),
                      // POST CONTENT
                      TextFormField(
                        key: UniqueKey(),
                        maxLines: 5,
                        initialValue: postDetailModel != null
                            ? postDetailModel.content
                            : 'đang tải...',
                        validator: (value) {
                          // if (value == null || value.isEmpty) {
                          //   return 'Không được bỏ trống';
                          // }
                          // if (value.length > 2000) {
                          //   return 'Nội dung phải nhỏ hơn 2000 kí tự';
                          // }
                          setState(() {
                            this.content = value;
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
                  } else {
                    print('not ok');
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
      'id': widget.postId,
      'title': title,
      'content': content,
    };

    var res = await Network().postData(data, '/post/edit_post');
    var body = json.decode(res.body);
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoadingPostDetailScreen(
          id: widget.postId,
        ),
      ),
    );
  }
}
