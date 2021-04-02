import 'package:flutter/cupertino.dart';
import 'package:flutter_login_test_2/constants/validate_name_constant.dart';

class ValidateService {
  chooseValidate({@required var option, @required var value}) {
    switch (option) {
      case kValidatePostTitleInput:
        return validatePostTitleInput(value: value);
        break;
      case kValidatePostContentInput:
        return validatePostContentInput(value: value);
        break;
    }
  }

  // validate post title input
  validatePostTitleInput({@required var value}) {
    if (value.isEmpty) {
      return 'Không được bỏ trống';
    }
    if (value.length > 20) {
      return 'Không được quá 20 kí tự';
    }
    return null;
  }

  // validate post content input
  validatePostContentInput({@required var value}) {
    if (value.isEmpty) {
      return 'Không được bỏ trống';
    }
    if (value.length > 200) {
      return 'Không được quá 200 kí tự';
    }
    return null;
  }
}
