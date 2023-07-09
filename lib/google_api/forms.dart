import 'package:forms_helper/entities/form.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GoogleFormsApi {
  final String url;

  GoogleFormsApi({required this.url});

  Future<http.Response> _post(
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

  Future<http.Response> _get(String endpoint, String token) async {
    final resp = await http.get(Uri.parse(endpoint),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      }
    );
    return resp;
  }

  Future<String> _create(GForm form, String token) async {
    final resp = await _post(url, {'info': form.baseInfo}, token);
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
    final res = await _post(formUrl, batchJson, token);
    print(res.statusCode);
  }

  Future<GForm?> get(String formUrl, String token) async {
    final re = RegExp(r'd\/(.*)\/');
    RegExpMatch? match = re.firstMatch(formUrl);
    if (match == null) {
      return null;
    }
    if (match.groupCount < 1) {
      return null;
    }
    final formId = match.group(1);
    final resp = await _get("${this.url}/$formId", token);
    if (resp.statusCode != 200) {
      return null;
    }
    Map<String, dynamic> rawJson = jsonDecode(resp.body);
    return GForm.fromJson(rawJson);
  }
}
