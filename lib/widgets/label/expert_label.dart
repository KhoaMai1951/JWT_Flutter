import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

expertLabelBuild() {
  return Row(
    children: [
      Container(
        margin: EdgeInsets.only(right: 5.0, bottom: 5.0),
        decoration: BoxDecoration(),
        child: Icon(
          Icons.star,
          color: Colors.yellow[800],
          size: 15.0,
        ),
      ),
      Text(
        'Chuyên gia cây cảnh',
        style: TextStyle(
          fontSize: 12.0,
          color: Colors.grey[600],
        ),
      ),
    ],
  );
}
