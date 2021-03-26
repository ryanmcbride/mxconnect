import 'dart:convert';
import 'package:http/http.dart' as http;

class Network {
  static String baseUrl = "http://localhost:5000";
  static Future<http.Response> getUserInfo(String deviceID) async {
    Map<String, dynamic> body = {
      'device_id': deviceID,
    };
    return http.post(baseUrl + '/createyourcompanyuser',
        body: json.encode(body),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        });
  }

  static Future<http.Response> getMXAccounts(String deviceID) async {
    return http.get(baseUrl + '/getaccounts/' + deviceID, headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
    });
  }

  static Future<http.Response> getConnectWidget(String deviceID) async {
    return http.get(baseUrl + '/getconnectwidget/' + deviceID, headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
    });
  }

  static Future<http.Response> createMXUSer(String deviceID) async {
    return http.post(baseUrl + '/createmxuser/' + deviceID, headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
    });
  }
}
