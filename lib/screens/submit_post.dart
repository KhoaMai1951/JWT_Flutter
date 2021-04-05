import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_test_2/components/MultiSelectChip.dart';
import 'package:flutter_login_test_2/constants/api_constant.dart';
import 'package:flutter_login_test_2/constants/bottom_bar_index_constant.dart';
import 'package:flutter_login_test_2/constants/validate_name_constant.dart';
import 'package:flutter_login_test_2/helpers/upload_image.dart';
import 'package:flutter_login_test_2/network_utils/api.dart';
import 'package:flutter_login_test_2/services/TagService.dart';
import 'package:flutter_login_test_2/widgets/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:flutter_login_test_2/widgets/text_form_field/text_form_field_universal.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class SubmitPostScreen extends StatefulWidget {
  var plantTagList;
  var contentTagList;

  SubmitPostScreen({this.plantTagList, this.contentTagList});

  @override
  _SubmitPostScreenState createState() => _SubmitPostScreenState(
      plantTagList: plantTagList, contentTagList: contentTagList);
}

class _SubmitPostScreenState extends State<SubmitPostScreen> {
  _SubmitPostScreenState({this.plantTagList, this.contentTagList});

  List<Asset> images = <Asset>[];
  List<MultipartFile> files = [];

  bool _plantTagListIsLoading = true;
  bool _contentTagListIsLoading = true;

  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  var title;
  var content;
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
    // Load plant tag list
    TagService.getTagsByTypeId(1).then((data) {
      setState(() {
        _plantTagListIsLoading = false;
        plantTagList = data;
      });
    });

    // Load content tag list
    TagService.getTagsByTypeId(2).then((data) {
      setState(() {
        _contentTagListIsLoading = false;
        contentTagList = data;
      });
    });
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
                      validateOption: kValidatePostContentInput,
                      maxLines: 5,
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
                    height: 40.0,
                  ),
                  SizedBox(
                    child: ElevatedButton(
                      child: Text("Chọn ảnh"),
                      onPressed: loadAssets,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: Text(
                        "Tag loại cây cảnh ($maxPlantTagCounter/2)",
                      ),
                    ),
                  ),
                  // DANH SÁCH CHIP LOẠI CÂY CẢNH
                  BuildPlantTagChip(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: Text(
                        "Tag loại cây cảnh ($maxContentTagCounter/2)",
                      ),
                    ),
                  ),
                  // DANH SÁCH CHIP NỘI DUNG BÀI VIẾT
                  BuildContentTagChip(),
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

    selectedPlantTagList.forEach((element) => {tagIds.add(element['id'])});
    selectedContentTagList.forEach((element) => {tagIds.add(element['id'])});

    var data = {
      'title': titleController.text,
      'content': contentController.text,
      'user_id': userId,
      'tag_ids': tagIds,
    };

    // var res = await Network().authData(data, '/post/submit_post');
    // var body = json.decode(res.body);
    // int status = res.statusCode;
    // print(status);
    // print(body);
    // if (status == 200) {
    //   Navigator.push(
    //     context,
    //     new MaterialPageRoute(
    //       builder: (context) => Home(),
    //     ),
    //   );
    // }

    // DIO
    List<MultipartFile> listFiles = await assetToFile() as List<MultipartFile>;
    print(listFiles);

    FormData formData = new FormData.fromMap({
      "files": listFiles,
      'title': titleController.text,
      'content': contentController.text,
      'user_id': userId,
      'tag_ids': tagIds,
    });

    Dio dio = new Dio();
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = jsonDecode(localStorage.getString('token'))['token'];
    if (token == null) {
      token = 1;
    }
    var response = await dio.post(
      kApiUrl + "/post/submit_post",
      data: formData,
      // options: Options(
      //   headers: {
      //     'Content-type': 'application/json',
      //     'Accept': 'application/json',
      //     'Authorization': 'Bearer $token',
      //   },
      // ),
    );
    print(response);
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

  BuildPlantTagChip() {
    if (_plantTagListIsLoading) return Text('loading...');
    return MultiSelectChip(
        list: this.plantTagList,
        onSelectionChanged: (selectedList, maxCounter) {
          setState(() {
            selectedPlantTagList = selectedList;
            this.maxPlantTagCounter = maxCounter;
          });
        });
  }

  BuildContentTagChip() {
    if (_contentTagListIsLoading) return Text('loading...');
    return MultiSelectChip(
        list: this.contentTagList,
        onSelectionChanged: (selectedList, maxCounter) {
          setState(() {
            selectedContentTagList = selectedList;
            this.maxContentTagCounter = maxCounter;
          });
        });
  }

  // LẤY ẢNH TRONG GALLERY VÀO LIST ASSET
  Future<void> loadAssets() async {
    this.images.clear();
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
    });
  }

  // CONVERT TỪ ASSET SANG MULTIPLE PART FILE
  Future<dynamic> assetToFile() async {
    files.clear();

    //images.forEach((asset) async {
    for (var asset in images) {
      int MAX_WIDTH = 500; //keep ratio
      int height = ((500 * asset.originalHeight) / asset.originalWidth).round();

      ByteData byteData =
          await asset.getThumbByteData(MAX_WIDTH, height, quality: 80);

      if (byteData != null) {
        List<int> imageData = byteData.buffer.asUint8List();
        MultipartFile u =
            await MultipartFile.fromBytes(imageData, filename: asset.name);

        setState(() {
          this.files.add(u);
        });
      }
    }
    ;

    return files;
  }

  // UPLOAD HÌNH LÊN S3
  Future<void> uploadImage() async {
    List<MultipartFile> listFiles = await assetToFile() as List<MultipartFile>;
    //print(listFiles);

    FormData formData = new FormData.fromMap({"files": files, "test": "test"});

    Dio dio = new Dio();
    var response = await dio.post(kApiUrl + "/post/test_dio", data: formData);
    //print(response);
  }

  // XUẤT HÌNH TỪ LIST ASSET RA ĐỂ REVIEW
  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 300,
          height: 300,
        );
      }),
    );
  }
}
