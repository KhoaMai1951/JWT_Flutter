import 'dart:convert';

import 'package:flutter_login_test_2/constants/api_constant.dart';
import 'package:flutter_login_test_2/network_utils/api.dart';

class TagService {
  static Future getTagsByTypeId(int tagTypeId) async {
    var res = await Network()
        .getData(kApiGetAllTagsByTagTypeId + tagTypeId.toString());
    var body = json.decode(res.body);
    return body;
  }
}
