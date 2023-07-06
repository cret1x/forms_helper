import 'package:flutter/material.dart';
import 'package:forms_helper/entities/form.dart';
import 'package:forms_helper/google_api/auth.dart';
import 'package:forms_helper/google_api/forms.dart';
import 'package:forms_helper/screens/home.dart';

import 'common/themes.dart';


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
  final api = GoogleFormsApi(url: "https://forms.googleapis.com/v1/forms");
  final auth = GoogleAuthApi();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: Themes.darkBlue,
        home: Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: () async {
                final f = GForm(title: "Test1", description: "Desc 1");
                final token = await auth.getAccessToken();
                //await api.create(f, token);
                Navigator.push(context, MaterialPageRoute(builder: (_) => HomeWidget()));
              },
              child: const Text("AUTH GOOGLE"),
            ),
          ),
        ),
    );
  }
}
