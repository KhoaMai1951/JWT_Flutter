import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

buildSnackBar({BuildContext context, String message}) {
  final snackBar = SnackBar(
    content: Text(message),
    duration: const Duration(seconds: 1),
    action: SnackBarAction(
      label: 'Đóng',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );
  // Find the ScaffoldMessenger in the widget tree
  // and use it to show a SnackBar.
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
