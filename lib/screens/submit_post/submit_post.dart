import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_test_2/components/MultiSelectChipForSubmitPost.dart';
import 'package:flutter_login_test_2/constants/api_constant.dart';
import 'package:flutter_login_test_2/constants/bottom_bar_index_constant.dart';
import 'package:flutter_login_test_2/constants/color_constant.dart';
import 'package:flutter_login_test_2/constants/validate_name_constant.dart';
import 'package:flutter_login_test_2/globals/user_global.dart';

import 'package:flutter_login_test_2/services/TagService.dart';
import 'package:flutter_login_test_2/widgets/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:flutter_login_test_2/widgets/text_form_field/text_form_field_universal.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../loading/loading_post_detail.dart';

class SubmitPostScreen extends StatefulWidget {
  //static const String id = 'submit_post_screen';
  @override
  _SubmitPostScreenState createState() => _SubmitPostScreenState();
}

class _SubmitPostScreenState extends State<SubmitPostScreen> {
  List<Asset> images = <Asset>[];
  List<MultipartFile> files = [];

  bool _plantTagListIsLoading = true;
  bool _contentTagListIsLoading = true;
  bool _exchangeTagListIsLoading = true;

  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  var title;
  var content;
  int maxPlantTagCounter = 0;
  int maxContentTagCounter = 0;
  int maxExchangeTagCounter = 0;

  //var plantTagList;
  var plantTagList;
  var selectedPlantTagList = [];
  //var contentTagList;
  var contentTagList;
  var selectedContentTagList = [];
  //var exchangeTagList;
  var exchangeTagList;
  var selectedExchangeTagList = [];
  var tagIds = [];

  TextEditingController contentController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  var userId;

  //audience target
  int audience = 1;

  void _handleRadioValueChange(int value) {
    setState(() {
      audience = value;
      switch (audience) {
        case 1:
          break;
        case 2:
          break;
      }
    });
  }

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

    // Load content tag list
    TagService.getTagsByTypeId(4).then((data) {
      setState(() {
        _exchangeTagListIsLoading = false;
        exchangeTagList = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ListViews',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: kAppBarColor,
          title: Text('Đăng bài'),
          centerTitle: true,
        ),
        body: bodyLayout(),
        bottomNavigationBar: buildBottomNavigationBar(
            context: context, index: kBottomBarIndexSubmitPost),
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
                  // TIÊU ĐỀ BÀI VIẾT
                  textFormFieldBuilder(
                    maxLines: 4,
                    label: 'Nhập tiêu đề',
                    hintText: 'Nhập tiêu đề',
                    validateFunction: (value) {
                      if (value.length == 0) {
                        return 'Xin nhập tiêu đề';
                      }
                      if (value.length > 1000) {
                        return 'Tiêu đề phải 1000 kí tự';
                      }
                      setState(() {
                        this.title = value;
                      });
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  // NỘI DUNG BÀI VIẾT
                  textFormFieldBuilder(
                    maxLines: 4,
                    label: 'Nhập nội dung bài viết',
                    hintText: 'Nhập nội dung bài viết',
                    validateFunction: (value) {
                      if (value.length > 1000) {
                        return 'Nội dung bài viết phải nhỏ hơn 1000 kí tự';
                      }
                      setState(() {
                        this.content = value;
                      });
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  // CHỌN ẢNH
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(kButtonColor),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.insert_photo),
                        Text("Chọn ảnh"),
                      ],
                    ),
                    onPressed: loadAssets,
                  ),
                  // VÙNG REVIEW ẢNH ĐÃ CHỌN
                  buildGridView(),
                  SizedBox(
                    height: 30.0,
                  ),
                  // TÊN TAG LOẠI CÂY CẢNH
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
                  //TÊN TAG NỘI DUNG
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: Text(
                        "Tag nội dung bài viết ($maxContentTagCounter/2)",
                      ),
                    ),
                  ),
                  // DANH SÁCH CHIP NỘI DUNG BÀI VIẾT
                  BuildContentTagChip(),
                  //TÊN TAG TRAO ĐỔI
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: Text(
                        "Tag trao đổi cây cảnh ($maxExchangeTagCounter/1)",
                      ),
                    ),
                  ),
                  // DANH SÁCH CHIP TRAO ĐỔI
                  BuildExchangeTagChip(),
                  // ĐỐI TƯỢNG XEM BÀI
                  SizedBox(
                    height: 30.0,
                  ),
                  // LỰA CHỌN ĐỐI TƯỢNG BÀI VIẾT
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: Text(
                        "Đối tượng bài viết",
                      ),
                    ),
                  ),
                  // CHỌN ĐỐI TƯỢNG
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          new Radio(
                            value: 1,
                            groupValue: audience,
                            onChanged: _handleRadioValueChange,
                          ),
                          new Text(
                            'Tất cả mọi người',
                            style: new TextStyle(fontSize: 16.0),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          new Radio(
                            value: 2,
                            groupValue: audience,
                            onChanged: _handleRadioValueChange,
                          ),
                          new Text(
                            'Chỉ chuyên gia',
                            style: new TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                    ],
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

    selectedPlantTagList.forEach((element) => {tagIds.add(element['id'])});
    selectedContentTagList.forEach((element) => {tagIds.add(element['id'])});
    selectedExchangeTagList.forEach((element) => {tagIds.add(element['id'])});

    // DIO
    List<MultipartFile> listFiles = await assetToFile() as List<MultipartFile>;
    FormData formData = new FormData.fromMap({
      "files": listFiles,
      'title': title,
      'content': content,
      'audience': audience,
      'user_id': UserGlobal.user['id'],
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
      options: Options(
        contentType: 'multipart/form-data',
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    var jsonData = json.decode(response.toString());
    print(jsonData);
    if (jsonData['status'] == true) {
      // Redirect to post detail
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoadingPostDetailScreen(
            id: jsonData['post_id'],
          ),
        ),
      );
    } else
      print('Failed');
    try {} catch (e) {
      print('exception: ' + e.toString());
      Future.error(e.toString());
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

  // BUILD CHIP PLANT
  BuildPlantTagChip() {
    if (_plantTagListIsLoading) return Text('đang tải...');
    return MultiSelectChip(
        selectLimit: 2,
        list: this.plantTagList,
        onSelectionChanged: (selectedList, maxCounter) {
          setState(() {
            selectedPlantTagList = selectedList;
            this.maxPlantTagCounter = maxCounter;
          });
        });
  }

  // BUILD CHIP CONTENT
  BuildContentTagChip() {
    if (_contentTagListIsLoading) return Text('đang tải...');
    return MultiSelectChip(
        selectLimit: 2,
        list: this.contentTagList,
        onSelectionChanged: (selectedList, maxCounter) {
          setState(() {
            selectedContentTagList = selectedList;
            this.maxContentTagCounter = maxCounter;
          });
        });
  }

  // BUILD CHIP EXCHANGE
  BuildExchangeTagChip() {
    if (_exchangeTagListIsLoading) return Text('đang tải...');
    return MultiSelectChip(
        selectLimit: 1,
        list: this.exchangeTagList,
        onSelectionChanged: (selectedList, maxCounter) {
          setState(() {
            selectedExchangeTagList = selectedList;
            this.maxExchangeTagCounter = maxCounter;
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
        maxImages: 9,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Chọn ảnh",
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

  // UPLOAD HÌNH LÊN SERVER
  Future<void> uploadImage() async {
    List<MultipartFile> listFiles = await assetToFile() as List<MultipartFile>;
    //print(listFiles);

    FormData formData = new FormData.fromMap({"files": files, "test": "test"});

    Dio dio = new Dio();
    var response = await dio.post(kApiUrl + "/post/test_dio", data: formData);
  }

  // XUẤT HÌNH TỪ LIST ASSET RA ĐỂ REVIEW
  Widget buildGridView() {
    return this.images.length != 0
        ? GridView.count(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 3,
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
