import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forms_helper/entities/answer.dart';
import 'package:forms_helper/entities/form.dart';
import 'package:forms_helper/entities/question.dart';
import 'package:forms_helper/google_api/auth.dart';
import 'package:forms_helper/google_api/forms.dart';
import 'package:forms_helper/screens/home.dart';

import 'common/themes.dart';

//TODO: set minimum window size
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
              ),
              ElevatedButton(
                onPressed: () async {
                  final token = await auth.getAccessToken();
                  final a = Answer(value: 'A');
                  final b = Answer(value: 'B');
                  final c = Answer(value: 'C');
                  final d = Answer(value: 'D');
                  final e = Answer(value: 'E');
                  final f = Answer(value: 'F');
                  final q1 = Question(
                      title: 'First',
                      description: 'Desc 1',
                      required: true,
                      shuffle: true,
                      pointValue: 1,
                      answers: [a, b, c],
                      correctAnswers: [a],
                      type: QuestionType.RADIO);
                  final q2 = Question(
                      title: 'Second',
                      description: 'Desc 2',
                      required: true,
                      shuffle: false,
                      pointValue: 2,
                      answers: [d, e, f],
                      correctAnswers: [d, e],
                      type: QuestionType.CHECKBOX);
                  final form = GForm(
                      title: "Test3",
                      description: "Description",
                      documentTitle: "Flutter Form",
                      questions: [q1, q2]);
                  api.create(form, token);
                },
                child: const Text("TEST CREATE"),
              ),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter a search term',
                ),
                controller: urlController,
              ),
              ElevatedButton(
                onPressed: () async {
                  final token = await auth.getAccessToken();
                  final form = await api.get(urlController.text, token);
                  //print(form?.info);
                  //print(form?.questions);
                },
                child: const Text("GET"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
