import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_test_2/constants/bottom_bar_index_constant.dart';
import 'package:flutter_login_test_2/constants/color_constant.dart';
import 'package:flutter_login_test_2/widgets/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:flutter_login_test_2/widgets/image_preview/image_preview.dart';
import 'package:flutter_login_test_2/widgets/upload_image/upload_image_button.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class ExpertRequestScreen extends StatefulWidget {
  @override
  _ExpertRequestScreenState createState() => _ExpertRequestScreenState();
}

class _ExpertRequestScreenState extends State<ExpertRequestScreen> {
  //fields varibles
  String bio;
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kAppBarColor,
        title: Text('Gửi yêu cầu \nlàm chuyên gia cây cảnh'),
      ),
      body: bodyLayout(),
      bottomNavigationBar: buildBottomNavigationBar(
          context: context, index: kBottomBarIndexProfile),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  // BODY
  bodyLayout() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(10.0),
      physics: AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          // FIELDS
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
          // Container(
          //   child: fieldsListView(),
          // ),
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
        ],
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
}
