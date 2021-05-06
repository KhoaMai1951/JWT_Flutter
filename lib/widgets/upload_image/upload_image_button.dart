import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_test_2/constants/color_constant.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class SubmitImageButton extends StatefulWidget {
  SubmitImageButton({
    this.onTapFunction,
    this.maximumImages,
    this.title,
  });
  Function onTapFunction;
  int maximumImages;
  String title;
  @override
  _SubmitImageButtonState createState() => _SubmitImageButtonState();
}

class _SubmitImageButtonState extends State<SubmitImageButton> {
  List<Asset> images = <Asset>[];
  List<MultipartFile> files = [];
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(kButtonColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.insert_photo),
          Text("Chọn ảnh"),
        ],
      ),
      onPressed: loadAssets,
    );
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
      } else {}
    }

    ;
    return files;
  }

  // LẤY ẢNH TRONG GALLERY VÀO LIST ASSET
  Future<void> loadAssets() async {
    this.images.clear();
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: widget.maximumImages,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: widget.title,
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

    // CONVERT TỪ ASSET SANG MULTIPART
    List<MultipartFile> listFiles = await assetToFile() as List<MultipartFile>;

    setState(() {
      files = listFiles;
      widget.onTapFunction(images, files);
    });
  }
}
