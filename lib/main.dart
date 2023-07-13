import 'package:firedart/firestore/firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forms_helper/entities/answer.dart';
import 'package:forms_helper/entities/form.dart';
import 'package:forms_helper/entities/choice_question.dart';
import 'package:forms_helper/firebase_functions/storage.dart';
import 'package:forms_helper/google_api/auth.dart';
import 'package:forms_helper/google_api/forms.dart';
import 'package:forms_helper/screens/home.dart';

import 'common/themes.dart';

//TODO: set minimum window size
void main() {
  Firestore.initialize("formshelper-f0d02");
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
  final urlController = TextEditingController();

  @override
  void dispose() {
    urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      restorationScopeId: "desktop-demo1",
      theme: Themes.darkBlue,
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () async {
                  final token = await auth.getAccessToken();
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => HomeWidget()));
                },
                child: const Text("AUTH GOOGLE"),
              ),ElevatedButton(
                onPressed: () async {
                  final fapi = FirestoreManager();
                  List<Answer> ans = [Answer(value: "A"), Answer(value: "B"), Answer(value: "C")];
                  List<ChoiceQuestion> q = [ChoiceQuestion(title: "First", description: "11", required: true, shuffle: false, pointValue: 1, options: ans, correctAnswers: [ans.first], type: QuestionType.RADIO)];
                  fapi.saveQuestions(q);
                  print(q.firstOrNull?.title);
                },
                child: const Text("1"),
              ),
              ElevatedButton(
                onPressed: () async {
                  final fapi = FirestoreManager();
                  final q = (await fapi.getQuestions(prefix: "Sec"));
                  final q2 = await fapi.isQuestionExist(q.first);
                  print(q2);
                  print(q.firstOrNull?.title);
                },
                child: const Text("2"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
