import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_test_2/constants/api_constant.dart';
import 'package:flutter_login_test_2/helpers/upload_image.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class UploadImage extends StatefulWidget {
  // uploadImageScreen({Key key, this.title}) : super(key: key);

  @override
  _UploadImageState createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Upload Image"),
        ),
        body: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 100,
                  height: 100,
                  child: RaisedButton(
                    onPressed: () {
                      getImage();
                    },
                    color: Colors.white,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(7.0)),
                    child: SizedBox(
                      width: 90,
                      height: 90,
                      child: Center(
                        child: Icon(
                          Icons.add,
                          color: Colors.deepOrange,
                          size: 30.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            SizedBox(
              width: 500,
              height: 500,
              child: _isUploading == true
                  ? FutureBuilder(
                      future: uploadImage(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                            return new Text('loading...');
                          default:
                            if (snapshot.hasError)
                              return new Text('${snapshot.error}');
                            else
                              return createListView(context, snapshot);
                        }
                      },
                    )
                  : Text(""),
            ),
          ],
        ));
  }

  Future getImage() async {
    files.clear();

    List<Asset> resultList = [];
    resultList = await MultiImagePicker.pickImages(
      maxImages: 2,
      enableCamera: false,
    );

    for (var asset in resultList) {
      int MAX_WIDTH = 500; //keep ratio
      int height = ((500 * asset.originalHeight) / asset.originalWidth).round();

      ByteData byteData =
          await asset.getThumbByteData(MAX_WIDTH, height, quality: 80);

      if (byteData != null) {
        List<int> imageData = byteData.buffer.asUint8List();
        MultipartFile u =
            MultipartFile.fromBytes(imageData, filename: asset.name);
        files.add(u);
      }
    }

    setState(() {
      _isUploading = true;
    });
  }

  List<MultipartFile> files = [];

  Future<List<String>> uploadImage() async {
    FormData formData = new FormData.fromMap({"files": files, "test": "test"});

    Dio dio = new Dio();
    var response = await dio.post(kApiUrl + "/post/test_dio", data: formData);

    UploadImageHelper image = UploadImageHelper.fromJson(response.data);
    return image.images;
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.hasError) {
      return Text("error createListView");
    }

    if (!snapshot.hasData) {
      return Text("");
    }

    List<String> values = snapshot.data;

    return new ListView.builder(
      shrinkWrap: true,
      itemCount: values.length,
      itemBuilder: (BuildContext context, int index) {
        return new Column(
          children: <Widget>[
            Image.network(
              values[index],
              width: 300,
              height: 100,
            ),
            SizedBox(
              height: 40,
            ),
          ],
        );
      },
    );
  }
}
