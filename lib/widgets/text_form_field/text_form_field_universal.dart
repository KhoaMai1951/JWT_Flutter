import 'package:flutter/material.dart';
import 'package:flutter_login_test_2/services/ValidateService.dart';

TextFormField TextFormFieldMethod(
    {@required String validateOption,
    @required String hintText,
    @required TextEditingController textEditingController,
    @required int maxLines}) {
  ValidateService validateService = new ValidateService();

  return TextFormField(
    style: TextStyle(color: Color(0xFF000000)),
    maxLines: maxLines,
    controller: textEditingController,
    cursorColor: Color(0xFF9b9b9b),
    keyboardType: TextInputType.text,
    decoration: InputDecoration(
      // prefixIcon: Icon(
      //   Icons.email,
      //   color: Colors.grey,
      // ),
      hintText: hintText,
      hintStyle: TextStyle(
          color: Color(0xFF9b9b9b),
          fontSize: 15,
          fontWeight: FontWeight.normal),
    ),
    validator: (value) {
      return validateService.chooseValidate(
          option: validateOption, value: value);
    },
  );
}
