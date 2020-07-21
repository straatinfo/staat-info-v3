import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:straatinfoflutter/backend/utils/backend_constants.dart';
import 'package:straatinfoflutter/backend/model/data_registration.dart';

class AuthService {

  Future<dynamic> verifyCode(String enteredCode) async {
    String url = base_url + enter_code_url;
    try {
     http.Response response = await http.post(url, body: {'code': enteredCode});
     return response.statusCode >= 200 && response.statusCode < 400;
     } catch(e) {
      print(e);
      return false;
    }
  }

  Future<dynamic> signin(String user, String pw) async {
    String url = base_url + signIn_url;
    try {
      http.Response response = await http.post(url, body: {'loginName': user, 'password': pw});
      return response.statusCode >= 200 && response.statusCode < 400;
    } catch(e) {
      return false;
    }
  }

  Future<dynamic> validateInput(String val, String field) async {
    String url = base_url + validateInput_url;
    try {
      http.Response response = await http.post(url, body: {field: val});
//      print(response.body);
      return response.statusCode >= 200 && response.statusCode < 400;
    } catch(e) {
      print(e);
      return false;
    }
  }



  Future<dynamic> signUp(DataRegistration regData, bool reporterData, String teamId) async {
    String gender;
    String urlSignup = base_url + signUp_url;
    if(regData.gender == 'Male') {
      gender = 'M';
    } else {
      gender = 'F';
    }

    try {
      print(teamId);
        http.Response response = await http.post(urlSignup, body: {
          'gender': gender,
          'fname': regData.fname,
          'lname': regData.lname,
          'username': regData.username,
          'postalCode': regData.postalCode,
          'houseNumber': regData.houseNumber,
          'streetName': regData.streetName,
          'email': regData.email,
          'phoneNumber': regData.phoneNumber,
          'password': regData.password,
          'state': regData.town,
          'city': regData.town,
          '_host': regData.hostId,
          'isVolunteer': reporterData.toString(),
          '_team': teamId,
//          'teamName': regData.username+'dummy',
//          'teamEmail': regData.username+'dummy@gmail.com',
//          'teamId': teamId,
        });
        String data = response.body;
        return jsonDecode(data);

    } catch (e) {
      var errorResponse = {"status": "FAILED", "httpCode": 500};
      print(e);
      return errorResponse;
    }

  }
}