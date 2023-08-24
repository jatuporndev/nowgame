import 'dart:convert';

import 'package:http/http.dart' as http;


class HttpService {
  Future<http.Response> getMethod(String url) async {
    final headers = {"Accept": "application/json",
      "Access-Control_Allow_Origin": "*"};
    final response = await http.get(Uri.parse(url), headers: headers);
    return response;
  }

  Future<http.Response> postMethod(String url, Map<String, dynamic> data) async {
    final headers = {'content-Type': 'application/json'};
    final response = await http.post(Uri.parse(url), headers: headers, body: jsonEncode(data));
    return response;
  }
}
