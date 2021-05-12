import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_test_2/constants/api_constant.dart';
import 'package:flutter_login_test_2/constants/bottom_bar_index_constant.dart';
import 'package:flutter_login_test_2/constants/color_constant.dart';
import 'package:flutter_login_test_2/globals/user_global.dart';
import 'package:flutter_login_test_2/widgets/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:flutter_login_test_2/widgets/image_preview/image_preview.dart';
import 'package:flutter_login_test_2/widgets/upload_image/upload_image_button.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExpertRequestScreen extends StatefulWidget {
  @override
  _ExpertRequestScreenState createState() => _ExpertRequestScreenState();
}

class _ExpertRequestScreenState extends State<ExpertRequestScreen> {
  //screen status
  int screenStatus = -1;
  //fields varibles
  String bio;
  String experienceIn;
  //image variables
  List<Asset> images = <Asset>[];
  List<MultipartFile> files = [];
  //loading
  bool isLoadingFields = false;
  //input fields
  var listInputFields = {
    'experience_in': '',
    'bio': '',
    'interested_in': '',
  };
  //form key
  final _formKey = GlobalKey<FormState>();
  //loading
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kAppBarColor,
        title: Text('Gửi yêu cầu \nlàm chuyên gia cây cảnh'),
      ),
      body: setBody(),
      //body: requestExpertBodyLayout(),
      bottomNavigationBar: buildBottomNavigationBar(
          context: context, index: kBottomBarIndexProfile),
    );
  }

  @override
  void initState() {
    super.initState();
    checkStatusOfUser();
  }

  setBody() {
    switch (screenStatus) {
      //đang tải
      case -1:
        return Center(
          child: Text('đang tải...'),
        );
        break;
      //chưa là expert
      case 0:
        return requestExpertBodyLayout();
        break;
      //pending expert
      case 1:
        return Center(
          child: Text('Đang chờ duyệt'),
        );
        break;
      //đã là expert
      case 2:
        return Container(
          child: Center(
            child: Text('Bạn đã là chuyên gia'),
          ),
        );
        break;
    }
  }

  // CHECK USER STATUS
  checkStatusOfUser() async {
    Dio dio = new Dio();
    var response = await dio.get(
      kApiUrl +
          "/expert_pending/check_status?user_id=" +
          UserGlobal.user['id'].toString(),
      options: Options(
        headers: {
          'Accept': 'application/json',
        },
      ),
    );

    var jsonData = json.decode(
      response.toString(),
    );
    setState(() {
      screenStatus = jsonData['status'].toInt();
    });
  }

  // BODY
  requestExpertBodyLayout() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(10.0),
      physics: AlwaysScrollableScrollPhysics(),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // BIO
            textFormFieldBuilder(
                hintText: 'tóm tắt bản thân',
                label: 'tóm tắt bản thân',
                maxLines: 5,
                validateFunction: (value) {
                  if (value.length > 2000) {
                    return 'Thông tin phải nhỏ hơn 2000 kí tự';
                  }
                  if (value.length == 0) {
                    return 'Phải nhập thông tin';
                  }
                  setState(() {
                    this.bio = value;
                  });
                  return null;
                }),
            SizedBox(height: 30.0),
            // EXPERIENCE IN
            textFormFieldBuilder(
                hintText: 'Chuyên về',
                label: 'Chuyên về',
                maxLines: 5,
                validateFunction: (value) {
                  if (value.length > 2000) {
                    return 'Thông tin phải nhỏ hơn 2000 kí tự';
                  }
                  if (value.length == 0) {
                    return 'Phải nhập thông tin';
                  }
                  setState(() {
                    this.experienceIn = value;
                  });
                  return null;
                }),
            SizedBox(
              height: 30.0,
            ),
            Text('Hình ảnh bằng cấp / chứng nhận / ...'),
            // IMAGE PICKER BUTTON
            SubmitImageButton(
              title: 'Chọn hình ảnh',
              maximumImages: 9,
              onTapFunction: (imagesAsset, imagesFile) async {
                setState(() {
                  this.images = imagesAsset;
                  this.files = imagesFile;
                });
              },
            ),
            // IMAGE REVIEW
            ImagePreview(
              images: images,
              listCount: 3,
              deleteImageFunction: (index) {
                setState(() {
                  this.images.removeAt(index);
                  this.files.removeAt(index);
                });
              },
            ),
            Divider(
              thickness: 4.0,
            ),
            // SUBMIT BUTTON
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: FlatButton(
                child: Padding(
                  padding:
                      EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 10),
                  child: Text(
                    _isLoading ? 'Đang xử lý...' : 'Gửi yêu cầu',
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                color: kButtonColor,
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
          ],
        ),
      ),
    );
  }

  // FIELDS LISTVIEW
  fieldsListView() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: listInputFields.length,
      itemBuilder: (context, index) {
        String key = listInputFields.keys.elementAt(index);
        return new Column(
          children: <Widget>[
            // new ListTile(
            //   title: new Text("$key"),
            //   subtitle: new Text("${listInputFields[key]}"),
            // ),
            textFormFieldBuilder(
              hintText: 'test',
            ),
            new Divider(
              height: 2.0,
              color: Colors.blue,
            ),
          ],
        );
      },
    );
  }

  // TEXT FORM FIELD
  textFormFieldBuilder(
      {String label,
      int maxLines,
      String hintText,
      Function validateFunction}) {
    return TextFormField(
      maxLines: maxLines,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: TextStyle(
          color: Colors.blueGrey,
        ),
        labelText: label,
        hintText: hintText,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey, width: 2.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey, width: 2.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      validator: validateFunction,
    );
  }

  void _postSubmit() async {
    setState(() {
      _isLoading = true;
    });

    FormData formData = new FormData.fromMap({
      "files": files,
      'bio': bio,
      'experience_in': experienceIn,
      'user_id': UserGlobal.user['id'],
    });

    Dio dio = new Dio();
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = jsonDecode(localStorage.getString('token'))['token'];

    try {
      var response = await dio.post(
        kApiUrl + "/expert_pending/request_expert",
        data: formData,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      var jsonData = json.decode(response.toString());
      if (jsonData['status'] == true) {
        // Redirect to profile
        Navigator.pop(context);
      } else
        print('Failed');
    } catch (e) {
      print('exception: ' + e.toString());
      Future.error(e.toString());
    }

    setState(() {
      _isLoading = false;
    });
  }
}
