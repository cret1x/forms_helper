import 'package:forms_helper/entities/form.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class GoogleFormsApi {
  final String url;
  final String token;

  GoogleFormsApi({required this.url, required this.token});

  Future<void> create(GForm form) async {
    final resp = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(form.toMap()),
    );
    print(resp);
    print(resp.statusCode);
    print(resp.body);
  }
}
