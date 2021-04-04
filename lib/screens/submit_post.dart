import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_test_2/components/MultiSelectChip.dart';
import 'package:flutter_login_test_2/constants/bottom_bar_index_constant.dart';
import 'package:flutter_login_test_2/constants/validate_name_constant.dart';
import 'package:flutter_login_test_2/network_utils/api.dart';
import 'package:flutter_login_test_2/widgets/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:flutter_login_test_2/widgets/text_form_field/text_form_field_universal.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class SubmitPostScreen extends StatefulWidget {
  var plantTagList;
  var contentTagList;

  SubmitPostScreen(
      {@required this.plantTagList, @required this.contentTagList});

  @override
  _SubmitPostScreenState createState() => _SubmitPostScreenState(
      plantTagList: plantTagList, contentTagList: contentTagList);
}

class _SubmitPostScreenState extends State<SubmitPostScreen> {
  _SubmitPostScreenState(
      {@required this.plantTagList, @required this.contentTagList});

  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  var email;
  var password;
  var username;
  var name;
  int maxPlantTagCounter = 0;
  int maxContentTagCounter = 0;

  var plantTagList;
  var selectedPlantTagList = [];
  var contentTagList;
  var selectedContentTagList = [];
  var tagIds = [];

  TextEditingController contentController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  var userId;

  @override
  void initState() {
    _loadUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ListViews',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text('Đăng bài')),
        body: bodyLayout(),
        bottomNavigationBar: buildBottomNavigationBar(
            context: context, index: kBottomBarIndexSubmitPost),
      ),
    );
  }

  bodyLayout() {
    return ListView(
      padding: EdgeInsets.all(20.0),
      children: <Widget>[
        Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: Text(
                        "Tiêu đề",
                      ),
                    ),
                  ),
                  // TIÊU ĐỀ BÀI VIẾT
                  TextFormFieldMethod(
                      validateOption: kValidatePostTitleInput,
                      maxLines: 1,
                      hintText: 'Nhập tiêu đề',
                      textEditingController: titleController),
                  SizedBox(
                    height: 30.0,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: Text(
                        "Nội dung bài viết",
                      ),
                    ),
                  ),
                  // NỘI DUNG BÀI VIẾT
                  TextFormFieldMethod(
                      validateOption: kValidatePostContentInput,
                      maxLines: 5,
                      hintText: 'Nhập nội dung',
                      textEditingController: contentController),
                  SizedBox(
                    height: 70.0,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: Text(
                        "Tag loại cây cảnh ($maxPlantTagCounter/2)",
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
                  SizedBox(
                    height: 20.0,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: Text(
                        "Tag nội dung ($maxContentTagCounter/2)",
                      ),
                    ),
                  ),
                  MultiSelectChip(
                    list: this.contentTagList,
                    onSelectionChanged: (selectedList, maxCounter) {
                      setState(() {
                        selectedContentTagList = selectedList;
                        this.maxContentTagCounter = maxCounter;
                      });
                    },
                  ),
                  // SUBMIT POST BUTTON
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: FlatButton(
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 8, bottom: 8, left: 10, right: 10),
                        child: Text(
                          _isLoading ? 'Proccessing...' : 'Submit Post',
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
                          borderRadius: new BorderRadius.circular(20.0)),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _postSubmit();
                        }
                      },
                    ),
                  ),
                  // TESTING BUTTON
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: FlatButton(
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 8, bottom: 8, left: 10, right: 10),
                        child: Text(
                          _isLoading ? 'Proccessing...' : 'Test get form data',
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
                          borderRadius: new BorderRadius.circular(20.0)),
                      onPressed: () {
                        selectedPlantTagList
                            .forEach((element) => {tagIds.add(element['id'])});
                        selectedContentTagList
                            .forEach((element) => {tagIds.add(element['id'])});
                      },
                    ),
                  ),
                  // TEST NAVIGATE BUTTON
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: FlatButton(
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 8, bottom: 8, left: 10, right: 10),
                        child: Text(
                          _isLoading ? 'Proccessing...' : 'Test navigate',
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
                          borderRadius: new BorderRadius.circular(20.0)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Home(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }

  void _postSubmit() async {
    setState(() {
      _isLoading = true;
    });

    selectedPlantTagList.forEach((element) => {tagIds.add(element['id'])});
    selectedContentTagList.forEach((element) => {tagIds.add(element['id'])});

    var data = {
      'title': titleController.text,
      'content': contentController.text,
      'user_id': userId,
      'tag_ids': tagIds,
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

  _loadUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user'));
    if (user != null) {
      setState(() {
        userId = user['id'];
      });
    }
  }
}
