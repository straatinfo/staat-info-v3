import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:straatinfoflutter/backend/utils/backend_constants.dart';
import 'package:device_info/device_info.dart';

class FeedbackService {
  Future<String> getDevicePlatform() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    String devicePlatform = '';

    if(Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
      if(iosInfo.utsname.machine != null) {
        devicePlatform = 'IOS - ${iosInfo.utsname.machine}';
      } else {
        devicePlatform = 'IOS - ?';
      }

    } else if(Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
      if(androidInfo.model != null) {
        devicePlatform = 'Android - ${androidInfo.model}';
      } else {
        devicePlatform = 'Android - ?';
      }
    } else {
      devicePlatform = 'Unknown';
    }
    return devicePlatform;
  }


  Future<dynamic> sendFeedback(String message, String device) async {
    String url = base_url + feedback_url;
    try {
      http.Response response = await http.post(
          url,
          body: {'message': message, 'device': device},
          headers: {
            HttpHeaders.authorizationHeader:
            "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI1ZWM4ZmVmZWIwNDYyZTAwMTdmODM1MGYiLCJpYXQiOjE1OTM3NzM3Njk1MTl9.d4j5yyuLH-uLp2nf0vbeL3tMWY6ecMNeXDcNhkNMdsc"
          }
      );
      print(response.body);
      return response.statusCode >= 200 && response.statusCode < 400;
    }
    catch(e) {
      var errorResponse = {"status": "FAILED", "httpCode": 500};
      return errorResponse;
    }


  }


}