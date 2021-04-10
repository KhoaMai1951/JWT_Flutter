import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingTest extends StatefulWidget {
  @override
  _LoadingTestState createState() => _LoadingTestState();
}

class _LoadingTestState extends State<LoadingTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              height: 50.0,
              child: Image.asset('images/logo.png'),
            ),
          ),
          SizedBox(
            height: 60.0,
          ),
          SpinKitRing(
            color: Colors.teal,
            lineWidth: 3.0,
            size: 40.0,
          ),
        ],
      ),
    );
  }
}
