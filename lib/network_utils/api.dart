import 'dart:convert';
import 'package:flutter_login_test_2/constants/api_constant.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Network {
  //final String _url = 'http://10.0.2.2:8000/api/v1';
  //if you are using android studio emulator, change localhost to 10.0.2.2
  var token;

  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    token = jsonDecode(localStorage.getString('token'))['token'];
    if (token == null) {
      token = 1;
    }
  }

  authData(data, apiUrl) async {
    //print(kApiUrl + apiUrl);
    var fullUrl = kApiUrl + apiUrl;
    return await http.post(fullUrl,
        body: jsonEncode(data), headers: _setHeaders());
  }

  getData(apiUrl) async {
    var fullUrl = kApiUrl + apiUrl;
    await _getToken();
    return await http.get(fullUrl, headers: _setHeaders());
  }

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };
}
