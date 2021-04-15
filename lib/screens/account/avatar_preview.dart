import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_test_2/constants/api_constant.dart';
import 'package:flutter_login_test_2/screens/loading/loading_user_profile.dart';
import 'package:flutter_login_test_2/widgets/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class AvatarPreviewScreen extends StatefulWidget {
  AvatarPreviewScreen({Key key, this.images, this.userId}) : super(key: key);
  List<Asset> images;
  int userId;
  @override
  _AvatarPreviewScreenState createState() => _AvatarPreviewScreenState();
}

class _AvatarPreviewScreenState extends State<AvatarPreviewScreen> {
  List<MultipartFile> files = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.teal,
        title: Row(children: [
          Expanded(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: new Text('Cập nhật \nhình đại diện'),
                ),
              ],
            ),
          ),
        ]),
        actions: [
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed))
                    return Colors.green;
                  return Colors.teal; // Use the component's default.
                },
              ),
            ),
            child: Icon(Icons.check),
            onPressed: () {
              uploadImage();
            },
          ),
        ],
      ),
      body: bodyLayout(),
      backgroundColor: Colors.black,
    );
  }

  bodyLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GridView.count(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 1,
          children: List.generate(widget.images.length, (index) {
            Asset asset = widget.images[index];
            return AssetThumb(
              asset: asset,
              width: 300,
              height: 300,
            );
          }),
        ),
      ],
    );
  }

  // CONVERT TỪ ASSET SANG MULTIPLE PART FILE
  Future<dynamic> assetToFile() async {
    files.clear();

    for (var asset in widget.images) {
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

    FormData formData =
        new FormData.fromMap({"files": listFiles, "user_id": widget.userId});
    //print(formData);

    Dio dio = new Dio();
    var response =
        await dio.post(kApiUrl + "/user/upload_avatar", data: formData);
    // print(response);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoadingProfileScreen(userId: widget.userId),
      ),
    );
  }
}
