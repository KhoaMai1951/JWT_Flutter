import 'dart:convert';

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_test_2/constants/bottom_bar_index_constant.dart';
import 'package:flutter_login_test_2/models/image_upload_model.dart';
import 'package:flutter_login_test_2/network_utils/api.dart';
import 'package:flutter_login_test_2/widgets/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:image_picker/image_picker.dart';

class SingleImageUpload extends StatefulWidget {
  @override
  _SingleImageUploadState createState() {
    return _SingleImageUploadState();
  }
}

class _SingleImageUploadState extends State<SingleImageUpload> {
  List<Object> images = [];
  Future<File> _imageFile;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      images.add("Add Image");
      images.add("Add Image");
      images.add("Add Image");
      //images.add("Add Image");
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          centerTitle: true,
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            Column(
              children: <Widget>[
                SizedBox(
                  height: 200,
                  child: buildGridView(),
                ),
              ],
            ),
            Column(
              children: [
                ElevatedButton(
                  child: Text('Test upload files'),
                  onPressed: () async {
                    List<File> files = [];
                    images.forEach((element) {
                      if (element is String) {
                      } else {
                        ImageUploadModel img = element;
                        files.add(img.imageFile);
                      }
                    });

                    ImageUploadModel img = images[0];
                    print(img.imageUrl);
                    var formData = FormData.fromMap({
                      'name': 'wendux',
                      'age': 25,
                      'files': await MultipartFile.fromFile(
                          '/storage/emulated/0/Download/download-1617263504-1617263517-9885-1617263666_r_680x0.jpg',
                          filename:
                              'download-1617263504-1617263517-9885-1617263666_r_680x0.jpg'),
                    });

                    print(formData.files);
                    Dio dio = new Dio();
                    var response = await dio.post(
                        'http://192.168.1.2:8000/api/v1/post/test_dio',
                        data: formData);
                    print(response.data);
                  },
                )
              ],
            ),
          ],
        ),
        bottomNavigationBar: buildBottomNavigationBar(
            context: context, index: kBottomBarIndexTestUploadImage),
      ),
    );
  }

  Widget buildGridView() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      childAspectRatio: 1,
      children: List.generate(images.length, (index) {
        if (images[index] is ImageUploadModel) {
          ImageUploadModel uploadModel = images[index];
          return Card(
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: <Widget>[
                Image.file(
                  uploadModel.imageFile,
                  width: 300,
                  height: 300,
                ),
                Positioned(
                  right: 5,
                  top: 5,
                  child: InkWell(
                    child: Icon(
                      Icons.remove_circle,
                      size: 20,
                      color: Colors.red,
                    ),
                    onTap: () {
                      setState(() {
                        images.replaceRange(index, index + 1, ['Add Image']);
                      });
                    },
                  ),
                ),
              ],
            ),
          );
        } else {
          return Card(
            child: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                _onAddImageClick(index);
              },
            ),
          );
        }
      }),
    );
  }

  Future _onAddImageClick(int index) async {
    setState(() {
      _imageFile = ImagePicker.pickImage(source: ImageSource.gallery);
      getFileImage(index);
    });
  }

  void getFileImage(int index) async {
    _imageFile.then((file) async {
      setState(() {
        ImageUploadModel imageUpload = new ImageUploadModel();
        imageUpload.isUploaded = false;
        imageUpload.uploading = false;
        imageUpload.imageFile = file;
        //imageUpload.imageUrl = '';
        imageUpload.imageUrl = file.path;

        images.replaceRange(index, index + 1, [imageUpload]);
      });
    });
  }
}
