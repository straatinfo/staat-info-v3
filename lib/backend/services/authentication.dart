import 'package:http/http.dart' as http;

class AuthenticationService {
  // @TODO base url should be a constant
  // @TODO urls should be a constant
  String baseUrl = 'https://straat-backend-v3.herokuapp.com';

  // AuthenticationService() {}

  Future<bool> verifyCode(String code) async {
    try {
      String url = baseUrl + '/v4/api/authentication/enterCode';
      http.Response response = await http.post(url, body: {'code': code});
      print(response.body);
      return response.statusCode >= 200 && response.statusCode < 400;
    } catch (e) {
      return false;
    }
  }
}
