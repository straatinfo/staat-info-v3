import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:straatinfoflutter/backend/utils/backend_constants.dart';

class PostalCodeService {
  Future<dynamic> verifyPostCode(String postcode, String houseNumber) async {
    String url = base_url + verify_postal_url + '?postcode=' + postcode + '&number=' + houseNumber;
    try {
        http.Response response = await http.get(url);
        String data = response.body;
        if(response.statusCode >= 200 && response.statusCode < 400) {
          return jsonDecode(data);
        } else {
          return 400;
        }
    }
    catch(e) {
      return false;
    }
  }


}