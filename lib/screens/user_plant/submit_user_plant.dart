import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_test_2/constants/api_constant.dart';
import 'package:flutter_login_test_2/constants/bottom_bar_index_constant.dart';
import 'package:flutter_login_test_2/constants/color_constant.dart';
import 'package:flutter_login_test_2/globals/user_global.dart';
import 'package:flutter_login_test_2/screens/user_plant/user_plant_news_feed.dart';
import 'package:flutter_login_test_2/widgets/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:flutter_login_test_2/widgets/upload_image/upload_image_button.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubmitUserPlantScreen extends StatefulWidget {
  @override
  _SubmitUserPlantScreenState createState() => _SubmitUserPlantScreenState();
}

class _SubmitUserPlantScreenState extends State<SubmitUserPlantScreen> {
  List<Asset> images = <Asset>[];
  List<MultipartFile> files = [];
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  var commonName;
  var scientificName;
  var description;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ListViews',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: kAppBarColor,
          title: Text('Đăng cây cảnh mới'),
          centerTitle: true,
        ),
        body: bodyLayout(),
        bottomNavigationBar: buildBottomNavigationBar(
            context: context, index: kBottomBarIndexProfile),
      ),
    );
  }

  bodyLayout() {
    return ListView(
      padding: EdgeInsets.all(10.0),
      children: <Widget>[
        Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // TÊN THƯỜNG GỌI
                  textFormFieldBuilder(
                    maxLines: 4,
                    label: 'Nhập tên thường gọi *',
                    hintText: 'Nhập tên thường gọi',
                    validateFunction: (value) {
                      if (value.length == 0) {
                        return 'Xin nhập tên thường gọi';
                      }
                      if (value.length > 1000) {
                        return 'Tên thường gọi < 1000 kí tự';
                      }
                      setState(() {
                        this.commonName = value;
                      });
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  // TÊN KHOA HỌC
                  textFormFieldBuilder(
                    maxLines: 4,
                    label: 'Nhập tên khoa học',
                    hintText: 'Nhập tên khoa học',
                    validateFunction: (value) {
                      if (value.length == 0) {
                        return 'Xin nhập tên khoa học';
                      }
                      if (value.length > 1000) {
                        return 'Tên khoa học phải < 1000 kí tự';
                      }
                      setState(() {
                        this.scientificName = value;
                      });
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  // MÔ TẢ
                  textFormFieldBuilder(
                    maxLines: 4,
                    label: 'Nhập mô tả',
                    hintText: 'Nhập mô tả',
                    validateFunction: (value) {
                      if (value.length == 0) {
                        return 'Xin nhập mô tả';
                      }
                      if (value.length > 1000) {
                        return 'Mô tả phải < 1000 kí tự';
                      }
                      setState(() {
                        this.scientificName = value;
                      });
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  // CHỌN ẢNH
                  SubmitImageButton(
                    maximumImages: 1,
                    title: 'Chọn ảnh cây cảnh',
                    onTapFunction: (imagesAsset, imagesFile) async {
                      setState(() {
                        this.images = imagesAsset;
                        this.files = imagesFile;
                      });
                    },
                  ),
                  // VÙNG REVIEW ẢNH ĐÃ CHỌN
                  buildGridView(),
                  SizedBox(
                    height: 30.0,
                  ),
                  // SUBMIT POST BUTTON
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: FlatButton(
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 8, bottom: 8, left: 10, right: 10),
                        child: Text(
                          _isLoading ? 'Đang xử lý...' : 'Đăng',
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
          ],
        ),
      ],
    );
  }

  void _postSubmit() async {
    setState(() {
      _isLoading = true;
    });

    FormData formData = new FormData.fromMap({
      "files": files,
      'common_name': commonName,
      'scientific_name': scientificName,
      'description': description,
      'user_id': UserGlobal.user['id'],
    });

    Dio dio = new Dio();
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = jsonDecode(localStorage.getString('token'))['token'];
    if (token == null) {
      token = 1;
    }
    try {
      var response = await dio.post(
        kApiUrl + "/user_plant/submit",
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
        // Redirect to post detail
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserPlantNewsFeedScreen(),
          ),
        );
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

  // XUẤT HÌNH TỪ LIST ASSET RA ĐỂ REVIEW
  Widget buildGridView() {
    return this.images.length != 0
        ? GridView.count(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 1,
            children: List.generate(images.length, (index) {
              Asset asset = images[index];
              return Container(
                margin: const EdgeInsets.all(1.0),
                child: AssetThumb(
                  asset: asset,
                  width: 300,
                  height: 300,
                ),
              );
            }),
          )
        : SizedBox();
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
}
