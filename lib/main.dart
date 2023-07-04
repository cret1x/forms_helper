import 'package:flutter/material.dart';
import 'package:firedart/firedart.dart';
import 'package:forms_helper/entities/answer.dart';
import 'package:forms_helper/entities/form.dart';
import 'package:forms_helper/entities/question.dart';
import 'package:forms_helper/google_api/api.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

void _launchAuthInBrowser(String url) async {
  print(url);
  await launchUrl(Uri.parse(url));
}

void loginWithDesktop() async {
  var id = ClientId(
    "120174249921-0r8bghb3a89v2j3g729ka7mq1h6bgccm.apps.googleusercontent.com",
    "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",
  );
  var scopes = [
    'https://www.googleapis.com/auth/forms.body',
  ];
  final client = http.Client();
  final r = await obtainAccessCredentialsViaUserConsent(id, scopes, client, (url) => _launchAuthInBrowser(url));
  print(r.idToken);
  print(r.accessToken.data);
  final api = GoogleFormsApi(url: "https://forms.googleapis.com/v1/forms", token: r.accessToken.data);
  final f = GForm(title: "Test1", description: "Desc 1");
  await api.create(f);
  client.close();
}

void main() {
  //Firestore.initialize("formshelper-f0d02");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            loginWithDesktop();
          },
          child: const Text("AUTH GOOGLE"),
        ),
      ),
    );
  }
}
