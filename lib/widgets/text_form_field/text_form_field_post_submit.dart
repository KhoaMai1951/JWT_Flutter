import 'package:flutter/material.dart';

TextFormField textFormFieldSubmitPost(
    {@required String hintText,
    @required String validateMessage,
    @required TextEditingController textEditingController,
    @required int maxLines}) {
  return TextFormField(
    style: TextStyle(color: Color(0xFF000000)),
    maxLines: maxLines,
    controller: textEditingController,
    cursorColor: Color(0xFF9b9b9b),
    keyboardType: TextInputType.text,
    decoration: InputDecoration(
      prefixIcon: Icon(
        Icons.email,
        color: Colors.grey,
      ),
      hintText: hintText,
      hintStyle: TextStyle(
          color: Color(0xFF9b9b9b),
          fontSize: 15,
          fontWeight: FontWeight.normal),
    ),
    validator: (value) {
      if (value.isEmpty) {
        return validateMessage;
      }
      return null;
    },
  );
}
