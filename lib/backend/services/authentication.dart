import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:straatinfoflutter/services/backend_constants.dart';

class AuthenticationService {
  Future<bool> verifyCode(String code) async {
    try {
      String url = baseUrl + enterCodeUrl;
      http.Response response = await http.post(url, body: {'code': code});
      print(response.body);
      return response.statusCode >= 200 && response.statusCode < 400;
    } catch (e) {
      return false;
    }
  }

  Future<bool> verifyRegistrationInput(String field, String value) async {
    try {
      String url = baseUrl + validateRegistrationInput;
      http.Response response = await http.post(url, body: {field: value});
      return response.statusCode >= 200 && response.statusCode < 400;
    } catch (e) {
      return false;
    }
  }

  Future<String> signin(String loginName, String password) async {
    String token;
    try {
      String url = baseUrl + signinUrl;
      http.Response response = await http
          .post(url, body: {'loginName': loginName, 'password': password});
      final responseBody = jsonDecode(response.body);
      token = responseBody['token'];
    } catch (e) {
      print(e.toString);
    }

    return token;
  }

  Future<String> signup(
      {String email,
      String password,
      String houseNumber,
      String streetName,
      String city,
      String state,
      String postalCode,
      String fname,
      String lname,
      String gender,
      String username,
      String hostId,
      bool isVolunteer,
      String teamId,
      String teamName,
      String teamEmail}) async {
    String token;
    try {
      String url = baseUrl + sianupUrl;
      http.Response response = await http.post(url, body: {
        'email': email,
        'password': password,
        'houseNumber': houseNumber,
        'streetName': streetName,
        'city': city,
        'state': state,
        'postalCode': postalCode,
        'fname': fname,
        'lname': lname,
        'gender': gender,
        'username': username,
        '_host': hostId,
        'isVolunteer': isVolunteer,
        '_team': teamId,
        'teamName': teamName,
        'teamEmail': teamEmail
      });
      final responseBody = jsonDecode(response.body);
      token = responseBody['token'];
    } catch (e) {
      print(e.toString);
    }

    return token;
  }
}
