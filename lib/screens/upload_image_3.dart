// // import 'dart:typed_data';
// //
// // import 'package:dio/dio.dart';
// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_login_test_2/constants/api_constant.dart';
// // import 'package:flutter_login_test_2/constants/bottom_bar_index_constant.dart';
// // import 'package:flutter_login_test_2/helpers/upload_image.dart';
// // import 'package:flutter_login_test_2/widgets/bottom_navigation_bar/bottom_navigation_bar.dart';
// // import 'package:multi_image_picker/multi_image_picker.dart';
// //
// // class UploadImage3 extends StatefulWidget {
// //   // uploadImageScreen({Key key, this.title}) : super(key: key);
// //
// //   @override
// //   _UploadImage3State createState() => _UploadImage3State();
// // }
// //
// // class _UploadImage3State extends State<UploadImage3> {
// //   bool _isUploading = false;
// //   List<MultipartFile> files = [];
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text("Upload Image"),
// //       ),
// //       body: ListView(padding: EdgeInsets.all(20.0), children: <Widget>[
// //         Column(
// //           children: [
// //             Form(
// //               child: TextFormField(
// //                 style: TextStyle(color: Color(0xFF000000)),
// //                 maxLines: 1,
// //                 cursorColor: Color(0xFF9b9b9b),
// //                 keyboardType: TextInputType.text,
// //               ),
// //             ),
// //             ElevatedButton(
// //               onPressed: () {
// //                 getImage();
// //               },
// //               child: Text('+'),
// //             ),
// //             ElevatedButton(
// //               onPressed: () {
// //                 print(files);
// //                 files.forEach((element) {
// //                   print(element.filename);
// //                 });
// //               },
// //               child: Text('Test list file'),
// //             ),
// //             // BoxDecoration(
// //             //   image: new DecorationImage(
// //             //     image: files[0],
// //             //   ),
// //             // ),
// //           ],
// //         )
// //       ]),
// //       bottomNavigationBar: buildBottomNavigationBar(context: context, index: 3),
// //     );
// //   }
// //
// //   Future getImage() async {
// //     files.clear();
// //
// //     List<Asset> resultList = [];
// //     resultList = await MultiImagePicker.pickImages(
// //       maxImages: 3,
// //       enableCamera: false,
// //     );
// //
// //     for (var asset in resultList) {
// //       int MAX_WIDTH = 500; //keep ratio
// //       int height = ((500 * asset.originalHeight) / asset.originalWidth).round();
// //
// //       ByteData byteData =
// //           await asset.getThumbByteData(MAX_WIDTH, height, quality: 80);
// //
// //       if (byteData != null) {
// //         List<int> imageData = byteData.buffer.asUint8List();
// //         MultipartFile u =
// //             MultipartFile.fromBytes(imageData, filename: asset.name);
// //         setState(() {
// //           files.add(u);
// //         });
// //       }
// //     }
// //
// //     setState(() {
// //       _isUploading = true;
// //     });
// //   }
// //
// //   Future<List<String>> uploadImage() async {
// //     FormData formData = new FormData.fromMap({"files": files, "test": "test"});
// //
// //     Dio dio = new Dio();
// //     var response = await dio.post(kApiUrl + "/post/test_dio", data: formData);
// //
// //     UploadImageHelper image = UploadImageHelper.fromJson(response.data);
// //     return image.images;
// //   }
// //
// //   Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
// //     if (snapshot.hasError) {
// //       return Text("error createListView");
// //     }
// //
// //     if (!snapshot.hasData) {
// //       return Text("");
// //     }
// //
// //     List<String> values = snapshot.data;
// //
// //     return new ListView.builder(
// //       shrinkWrap: true,
// //       itemCount: values.length,
// //       itemBuilder: (BuildContext context, int index) {
// //         return new Column(
// //           children: <Widget>[
// //             Image.network(
// //               values[index],
// //               width: 300,
// //               height: 100,
// //             ),
// //             SizedBox(
// //               height: 40,
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }
// // }
//
// import 'dart:io';
// import 'dart:typed_data';
//
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_login_test_2/constants/api_constant.dart';
// import 'package:flutter_login_test_2/helpers/upload_image.dart';
// import 'dart:async';
//
// import 'package:multi_image_picker/multi_image_picker.dart';
//
// class UploadImage3 extends StatefulWidget {
//   @override
//   _UploadImage3State createState() => _UploadImage3State();
// }
//
// class _UploadImage3State extends State<UploadImage3> {
//   List<Asset> images = <Asset>[];
//   List<MultipartFile> files = [];
//   String _error = 'No Error Dectected';
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   // LẤY ẢNH TRONG GALLERY VÀO LIST ASSET
//   Future<void> loadAssets() async {
//     this.images.clear();
//     List<Asset> resultList = <Asset>[];
//     String error = 'No Error Detected';
//
//     try {
//       resultList = await MultiImagePicker.pickImages(
//         maxImages: 300,
//         enableCamera: true,
//         selectedAssets: images,
//         cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
//         materialOptions: MaterialOptions(
//           actionBarColor: "#abcdef",
//           actionBarTitle: "Example App",
//           allViewTitle: "All Photos",
//           useDetailsView: false,
//           selectCircleStrokeColor: "#000000",
//         ),
//       );
//     } on Exception catch (e) {
//       error = e.toString();
//     }
//
//     // If the widget was removed from the tree while the asynchronous platform
//     // message was in flight, we want to discard the reply rather than calling
//     // setState to update our non-existent appearance.
//     if (!mounted) return;
//
//     setState(() {
//       images = resultList;
//       _error = error;
//     });
//   }
//
//   // CONVERT TỪ ASSET SANG MULTIPLE PART FILE
//   Future<dynamic> assetToFile() async {
//     files.clear();
//
//     //images.forEach((asset) async {
//     for (var asset in images) {
//       int MAX_WIDTH = 500; //keep ratio
//       int height = ((500 * asset.originalHeight) / asset.originalWidth).round();
//
//       ByteData byteData =
//           await asset.getThumbByteData(MAX_WIDTH, height, quality: 80);
//
//       if (byteData != null) {
//         List<int> imageData = byteData.buffer.asUint8List();
//         MultipartFile u =
//             await MultipartFile.fromBytes(imageData, filename: asset.name);
//
//         setState(() {
//           this.files.add(u);
//         });
//         print(this.files);
//       }
//     }
//     ;
//
//     return files;
//   }
//
//   // UPLOAD HÌNH LÊN S3
//   Future<void> uploadImage() async {
//     List<MultipartFile> listFiles = await assetToFile() as List<MultipartFile>;
//     print(listFiles);
//
//     FormData formData =
//         new FormData.fromMap({"files": listFiles, "test": "test"});
//
//     Dio dio = new Dio();
//     var response = await dio.post(kApiUrl + "/post/test_dio", data: formData);
//     print(response);
//   }
//
//   // XUẤT HÌNH TỪ LIST ASSET RA ĐỂ REVIEW
//   Widget buildGridView() {
//     return GridView.count(
//       crossAxisCount: 3,
//       children: List.generate(images.length, (index) {
//         Asset asset = images[index];
//         return AssetThumb(
//           asset: asset,
//           width: 300,
//           height: 300,
//         );
//       }),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Plugin example app'),
//         ),
//         body: Column(
//           children: <Widget>[
//             Center(child: Text('Error: $_error')),
//             ElevatedButton(
//               child: Text("Pick images"),
//               onPressed: loadAssets,
//             ),
//             ElevatedButton(
//               child: Text("Upload images"),
//               onPressed: uploadImage,
//             ),
//             Expanded(
//               child: buildGridView(),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
