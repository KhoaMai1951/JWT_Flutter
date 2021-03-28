// import 'dart:html';
//
// import 'package:dio/dio.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;
//   File _image;
//   final GlobalKey<ScaffoldState> _scaffoldstate =
//       new GlobalKey<ScaffoldState>();
//
//   Future getImage() async {
//     var image = await ImagePicker.pickImage(source: ImageSource.camera);
//     _uploadFile(image);
//
//     setState(() {
//       _image = image;
//     });
//   }
//
//   void _incrementCounter() {
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter++;
//     });
//   }
//
//   // Methode for file upload
//   void _uploadFile(filePath) async {
//     // Get base file name
//     String fileName = basename(filePath.path);
//     print("File base name: $fileName");
//
//     try {
//       FormData formData =
//           new FormData.from({"file": new UploadFileInfo(filePath, fileName)});
//
//       Response response =
//           await Dio().post("http://192.168.0.101/saveFile.php", data: formData);
//       print("File upload response: $response");
//
//       // Show the incoming message in snakbar
//       _showSnakBarMsg(response.data['message']);
//     } catch (e) {
//       print("Exception Caught: $e");
//     }
//   }
//
//   // Method for showing snak bar message
//   void _showSnakBarMsg(String msg) {
//     _scaffoldstate.currentState
//         .showSnackBar(new SnackBar(content: new Text(msg)));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       key: _scaffoldstate,
//       appBar: AppBar(
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: _image == null ? Text('No image selected.') : Image.file(_image),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: getImage,
//         tooltip: 'Increment',
//         child: Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
