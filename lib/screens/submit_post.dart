import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_login_test_2/components/MultiSelectChip.dart';
import 'package:flutter_login_test_2/models/TagModel.dart';
import 'package:flutter_login_test_2/network_utils/api.dart';
import 'package:flutter_login_test_2/widgets/text_form_field/text_form_field_post_submit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';
import 'login.dart';

class SubmitPost extends StatefulWidget {
  @override
  _SubmitPostState createState() => _SubmitPostState();
}

class _SubmitPostState extends State<SubmitPost> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  var email;
  var password;
  var username;
  var name;
  int maxPlantTagCounter = 0;
  int maxContentTagCounter = 0;

  // Plant tag list
  List<TagModel> plantTagList = [
    new TagModel(tagId: 1, tagName: 'cây Lan'),
    new TagModel(tagId: 2, tagName: 'cây văn phòng'),
    new TagModel(tagId: 3, tagName: 'cây xương rồng'),
    new TagModel(tagId: 33, tagName: 'cây sân vườn'),
  ];
  List<TagModel> selectedPlantTagList = [];

  // Content tag list
  List<TagModel> contentTagList = [
    new TagModel(tagId: 4, tagName: 'tâm sự'),
    new TagModel(tagId: 5, tagName: 'hướng dẫn'),
    new TagModel(tagId: 6, tagName: 'mẹo vặt'),
  ];
  List<TagModel> selectedContentTagList = [];

  TextEditingController contentController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  var userId;

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
        userId = user['id'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.teal,
        child: Stack(
          children: <Widget>[
            Positioned(
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Card(
                      elevation: 4.0,
                      color: Colors.white,
                      margin: EdgeInsets.only(left: 5, right: 5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              textFormFieldSubmitPost(
                                  hintText: "Enter your post title here",
                                  validateMessage: "Please enter title",
                                  textEditingController: titleController,
                                  maxLines: 1),
                              textFormFieldSubmitPost(
                                  hintText: "Enter your content here",
                                  validateMessage: "Please enter content",
                                  textEditingController: contentController,
                                  maxLines: 5),
                              SizedBox(
                                height: 70.0,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  child: Text(
                                    "Tag loại cây cảnh ($maxPlantTagCounter/3)",
                                  ),
                                ),
                              ),
                              MultiSelectChip(
                                list: this.plantTagList,
                                onSelectionChanged: (selectedList, maxCounter) {
                                  setState(() {
                                    selectedPlantTagList = selectedList;
                                    this.maxPlantTagCounter = maxCounter;
                                  });
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: FlatButton(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 8, bottom: 8, left: 10, right: 10),
                                    child: Text(
                                      _isLoading
                                          ? 'Proccessing...'
                                          : 'Submit Post',
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
                                      _postSubmit();
                                    }
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: FlatButton(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 8, bottom: 8, left: 10, right: 10),
                                    child: Text(
                                      _isLoading ? 'Proccessing...' : 'Testing',
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
                                    print(this
                                        .selectedPlantTagList
                                        .first
                                        .tagName);
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

  void _postSubmit() async {
    setState(() {
      _isLoading = true;
    });
    var data = {
      'title': titleController.text,
      'content': contentController.text,
      'user_id': userId,
    };

    var res = await Network().authData(data, '/post/submit_post');
    var body = json.decode(res.body);
    int status = res.statusCode;
    print(status);
    print(body);
    if (status == 200) {
      Navigator.push(
        context,
        new MaterialPageRoute(
          builder: (context) => Home(),
        ),
      );
    }
    setState(() {
      _isLoading = false;
    });
  }
}
