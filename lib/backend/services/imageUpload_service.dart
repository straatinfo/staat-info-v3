import 'dart:convert';
import 'dart:io';
//import 'package:http/http.dart' as http;
import 'package:straatinfoflutter/backend/utils/backend_constants.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';


class ImageUploadService {
  Future<dynamic> uploadImage(File imageFile) async {
    String url = base_url + imageUpload_url;
    try {
      final dio = Dio();
      String fileName = imageFile.path.split('/').last;
//      print(fileName);
//      print(imageFile);

      FormData formData = new FormData.fromMap({
        'media' :
          await MultipartFile.fromFile(imageFile.path, filename: fileName,
            contentType: MediaType('image', 'png')),
            'type': 'image/png'
      });
      Response response = await dio.post(url, data: formData, options: Options(
        headers: {
          'Content-Type': 'multipart/form-data'
        }
      ));
      print(response);
      return jsonDecode(response.toString());
    }
    catch(e) {
      var errorResponse = {"status": "FAILED", "httpCode": 500};
      print(e);
      return errorResponse;
    }

  }




}


