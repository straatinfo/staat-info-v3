import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:straatinfoflutter/services/backend_constants.dart';

class UtilitiyService {
  Future<dynamic> verifyPostcode(String postcode, String houseNumber) async {
    dynamic a;
    try {
      String url = baseUrl +
          enterCodeUrl +
          '?postcode=' +
          postcode +
          '&number' +
          houseNumber;
      http.Response response = await http.get(url);
      a = jsonDecode(response.body) as dynamic;
    } catch (e) {
      print(e.toString());
    }

    return a;
  }
}
