import 'package:firedart/firestore/firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:forms_helper/common/strings.dart';
import 'package:forms_helper/entities/answer.dart';
import 'package:forms_helper/entities/form.dart';
import 'package:forms_helper/entities/choice_question.dart';
import 'package:forms_helper/entities/form_item.dart';
import 'package:forms_helper/entities/question_item.dart';
import 'package:forms_helper/entities/text_question.dart';
import 'package:forms_helper/firebase_functions/storage.dart';
import 'package:forms_helper/google_api/auth.dart';
import 'package:forms_helper/google_api/forms.dart';
import 'package:forms_helper/screens/export/export.dart';
import 'package:forms_helper/screens/home.dart';
import 'package:forms_helper/sqlite/local_storage.dart';

import 'common/themes.dart';

//TODO: set minimum window size
void main() {
  Firestore.initialize("formshelper-f0d02");
  runApp(const ProviderScope(child: MyApp()));
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                Strings.appTitle,
                style: TextStyle(fontSize: 32),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 8.0, bottom: 40),
                child: Text(
                  Strings.appDescription,
                  style: TextStyle(fontSize: 24),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FutureBuilder(
                  future: auth.hasLoggedIn,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.onPrimary,
                      );
                    }
                    if (snapshot.hasData) {
                      if (snapshot.data!) {
                        Future.delayed(const Duration(seconds: 1), () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const HomeWidget()));
                        });
                        return CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.onPrimary,
                        );
                      }
                    }
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const HomeWidget()));
                      },
                      borderRadius: BorderRadius.circular(15),
                      child: Ink(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: const Color(0xFFFFFFFF),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.only(
                              left: 24, right: 30, top: 8, bottom: 8),
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Image(
                                image: AssetImage(
                                  'assets/google_logo.png',
                                ),
                                height: 28,
                              ),
                              SizedBox(width: 12),
                              Text(
                                Strings.signInWithGoogle,
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.blueGrey),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
