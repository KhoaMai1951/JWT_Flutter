import 'dart:convert';
import 'package:flutter_login_test_2/constants/api_constant.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Network {
  var token;

  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    token = jsonDecode(localStorage.getString('token'))['token'];
    if (token == null) {
      token = 1;
    }
  }

  authData(data, apiUrl) async {
    var fullUrl = kApiUrl + apiUrl;
    Uri myUri = Uri.parse(fullUrl);
    //await _getToken();
    //return await http.post(fullUrl, body: jsonEncode(data), headers: _setHeaders());
    return await http.post(myUri,
        body: jsonEncode(data), headers: _setHeaders());
  }

  postData(data, apiUrl) async {
    //print(kApiUrl + apiUrl);
    var fullUrl = kApiUrl + apiUrl;
    Uri myUri = Uri.parse(fullUrl);
    await _getToken();
    //return await http.post(fullUrl, body: jsonEncode(data), headers: _setHeaders());
    return await http.post(myUri,
        body: jsonEncode(data), headers: _setHeaders());
  }

  getData(apiUrl) async {
    var fullUrl = kApiUrl + apiUrl;
    Uri myUri = Uri.parse(fullUrl);

    await _getToken();
    //return await http.get(fullUrl, headers: _setHeaders());
    return await http.get(myUri, headers: _setHeaders());
  }

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
}
