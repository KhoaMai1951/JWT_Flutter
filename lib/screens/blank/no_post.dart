import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoPostScreen extends StatefulWidget {
  @override
  _NoPostScreenState createState() => _NoPostScreenState();
}

class _NoPostScreenState extends State<NoPostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text('Không tìm được bài viết'),
          ),
        ],
      ),
    );
  }
}
