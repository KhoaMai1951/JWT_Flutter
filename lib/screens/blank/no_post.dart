import 'package:flutter/cupertino.dart';

class NoPostScreen extends StatefulWidget {
  @override
  _NoPostScreenState createState() => _NoPostScreenState();
}

class _NoPostScreenState extends State<NoPostScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Không có bài viết nào :<'),
    );
  }
}
