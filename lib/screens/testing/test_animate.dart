import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnimatedFlutterLogo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _AnimatedFlutterLogoState();
}

class _AnimatedFlutterLogoState extends State<AnimatedFlutterLogo> {
  Timer _timer;
  FlutterLogoStyle _logoStyle = FlutterLogoStyle.markOnly;

  _AnimatedFlutterLogoState() {
    _timer = new Timer(const Duration(milliseconds: 100), () {
      setState(() {
        _logoStyle = FlutterLogoStyle.horizontal;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return new FlutterLogo(
      size: 200.0,
      // textColor: _logoStyle,
      style: _logoStyle,
    );
  }
}
