import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CannotConnectServerScreen extends StatefulWidget {
  @override
  _CannotConnectServerScreenState createState() =>
      _CannotConnectServerScreenState();
}

class _CannotConnectServerScreenState extends State<CannotConnectServerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text('Không kết nối được server'),
          ),
        ],
      ),
    );
  }
}
