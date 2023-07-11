import 'package:firedart/firestore/firestore.dart';
import 'package:forms_helper/entities/form.dart';
import 'package:forms_helper/entities/question.dart';

class FirestoreManager {
  static final FirestoreManager _firestoreManager = FirestoreManager._internal();
  factory FirestoreManager() {
    return _firestoreManager;
  }
  FirestoreManager._internal();


  Future<List<Question>> getQuestions({String? prefix}) async {
    final questionsCollection = Firestore.instance.collection('questions');
    final questionsDocuments = await questionsCollection.get();
    final questions = <Question>[];
    for (var doc in questionsDocuments) {
      questions.add(Question.fromJson(doc.map));
    }
    return questions;
  }
  
  Future<void> saveQuestions(List<Question> questions) async {
    final questionsCollection = Firestore.instance.collection('questions');
    for (var question in questions) {
      questionsCollection.add(question.toMap());
    }
  }

  Future<void> saveForm(GForm form) async {
    final formsCollection = Firestore.instance.collection('forms');
    formsCollection.add(form.toMap());
  }

  Future<List<GForm>> getForms() async {
    final formsCollection = Firestore.instance.collection('forms');
    final formDocuments = await formsCollection.get();
    final forms = <GForm>[];
    for (var doc in formDocuments) {
      forms.add(GForm.fromJson(doc.map));
    }
    return forms;
  }
}