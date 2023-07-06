import 'package:forms_helper/entities/form.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GoogleFormsApi {
  final String url;

  GoogleFormsApi({required this.url});

  Future<http.Response> _makePost(
      String endpoint, Map<String, dynamic> json, String token) async {
    final resp = await http.post(
      Uri.parse(endpoint),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(json),
    );
    return resp;
  }

  Future<String> _create(GForm form, String token) async {
    final resp = await _makePost(url, {'info': form.baseInfo}, token);
    final jsonResponse = jsonDecode(resp.body);
    return jsonResponse['formId'];
  }

  Future<void> create(GForm form, String token) async {
    final formId = await _create(form, token);
    final formUrl = '$url/$formId:batchUpdate';

    final updateInfoJson = {
      'updateFormInfo': {'info': form.info, 'updateMask': 'description'}
    };
    final updateSettingJson = {
      'updateSettings': {
        'settings': {
          'quizSettings': {
            'isQuiz': form.isQuiz,
          }
        },
        'updateMask': '*'
      },
    };
    final List<Map<String, dynamic>> items = [];
    for (int i = 0; i < (form.questions?.length ?? 0); i++) {
      items.add({
        'createItem': {
          'item': form.questions![i].toMap(),
          'location': {
            'index': i,
          },
        },
      });
    }
    final batchJson = {
      'includeFormInResponse': false,
      'requests': [updateInfoJson, updateSettingJson, ...items],
    };
    final res = await _makePost(formUrl, batchJson, token);
    print(res.body);
  }
}
