import 'package:firedart/firestore/firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forms_helper/entities/answer.dart';
import 'package:forms_helper/entities/form.dart';
import 'package:forms_helper/entities/choice_question.dart';
import 'package:forms_helper/entities/form_item.dart';
import 'package:forms_helper/entities/question_item.dart';
import 'package:forms_helper/entities/text_question.dart';
import 'package:forms_helper/firebase_functions/storage.dart';
import 'package:forms_helper/google_api/auth.dart';
import 'package:forms_helper/google_api/forms.dart';
import 'package:forms_helper/screens/home.dart';
import 'package:forms_helper/sqlite/local_storage.dart';

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
  final local = LocalStorage();

  @override
  void dispose() {
    urlController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    local.init();
    super.initState();
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
                  if (!local.isInitialized) {
                    print('Not ready!');
                    return;
                  }
                  final t1 = await local.getQuestions();
                  final t2 = await local.getQuestions(searchText: 'sim');
                  final t3 = await local.getQuestions(tag: 'A');
                  print(t1.join(', '));
                  print(t2.join(', '));
                  print(t3.join(', '));
                  print(local.questionsCount);
                },
                child: const Text("1"),
              ),
              ElevatedButton(
                onPressed: () async {
                  List<Answer> options = [
                    Answer(value: 'Вариант 1'),
                    Answer(value: 'Вариант 2'),
                    Answer(value: 'Вариант 3'),
                    Answer(value: 'Вариант 4'),
                  ];
                  List<Answer> correct = [
                    Answer(value: 'Вариант 1'),
                    Answer(value: 'Вариант 3'),
                  ];
                  List<QuestionItem> questions = [
                    TextQuestion(
                        title: "Почта",
                        description: "",
                        required: true,
                        pointValue: 0,
                        correctAnswers: [],
                        paragraph: false,
                        tag: ''),
                    TextQuestion(
                        title: "Группа",
                        description: "",
                        required: true,
                        pointValue: 0,
                        correctAnswers: [],
                        paragraph: false,
                        tag: ''),
                    ChoiceQuestion(
                        title: "Вопрос с выбором",
                        description: '',
                        required: true,
                        shuffle: false,
                        pointValue: 1,
                        options: options,
                        correctAnswers: correct,
                        type: QuestionType.RADIO,
                        tag: 'Мозг'),
                  ];
                  final fapi = FirestoreManager();
                  await fapi.saveQuestions(questions);
                  print('Done!');
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
