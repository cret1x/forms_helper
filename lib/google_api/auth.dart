import 'dart:io';
import 'dart:convert';

import 'package:googleapis_auth/auth_io.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;


class GoogleAuthApi {
  static const refreshTokenPath = 'FormsHelper/token.txt';
  static final GoogleAuthApi _googleAuthApi = GoogleAuthApi._internal();
  static final id = ClientId(
    "120174249921-0r8bghb3a89v2j3g729ka7mq1h6bgccm.apps.googleusercontent.com",
    "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",
  );
  static final scopes = [
    'https://www.googleapis.com/auth/forms.body',
  ];

  factory GoogleAuthApi() {
    return _googleAuthApi;
  }

  GoogleAuthApi._internal();

  Future<File> get _localTokenFile async {
    final path = (await getApplicationDocumentsDirectory()).path;
    return File('$path/$refreshTokenPath');
  }

  Future<AccessCredentials?> _getCredentials() async {
    try {
      final file = await _localTokenFile;
      final jsonString = await file.readAsString();
      final credentials = AccessCredentials.fromJson(jsonDecode(jsonString));
      return credentials;
    } catch (e) {
      return null;
    }
  }
  
  Future<bool> _saveCredentials(AccessCredentials credentials) async {
    try {
      final file = await _localTokenFile;
      await file.create(recursive: true);
      await file.writeAsString(jsonEncode(credentials.toJson()));
      return true;
    } catch (e) {
      return false;
    }
  }

  void _launchInBrowser(String url) async {
    await launchUrl(Uri.parse(url));
  }

  Future<String> getAccessToken() async {
    final credentials = await _getCredentials();
    if (credentials == null) {
      return _firstAuth();
    } else {
      final client = http.Client();
      final r = await refreshCredentials(id, credentials, client);
      client.close();
      return r.accessToken.data;
    }
  }

  Future<String> _firstAuth() async {
    final client = http.Client();
    final r = await obtainAccessCredentialsViaUserConsent(id, scopes, client, (url) => _launchInBrowser(url));
    if (r.refreshToken != null) {
      final success = await _saveCredentials(r);
      print(success);
      return r.accessToken.data; 
    }
    client.close();
    return "";
  }
}