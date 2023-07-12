import 'package:firedart/firestore/firestore.dart';
import 'package:firedart/firestore/models.dart';
import 'package:forms_helper/entities/form.dart';
import 'package:forms_helper/entities/question.dart';

class FirestoreManager {
  static final FirestoreManager _firestoreManager = FirestoreManager._internal();
  static const int pageSize = 20;
  factory FirestoreManager() {
    return _firestoreManager;
  }
  FirestoreManager._internal();


  Future<List<Question>> getQuestions({String? prefix}) async {
    final questionsCollection = Firestore.instance.collection('questions');
    final questions = <Question>[];
    late List<Document> questionsDocuments;
    if (prefix == null || prefix.isEmpty) {
      questionsDocuments = await questionsCollection.limit(pageSize).get();
    } else {
      var next = prefix.codeUnitAt(0);
      next++;
      String nextPrefix = String.fromCharCode(next);
      final query = questionsCollection.where('title', isGreaterThanOrEqualTo: prefix).where('title', isLessThan: nextPrefix).limit(pageSize);
      questionsDocuments = await query.get();
    }
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

  Future<bool> isQuestionExist(Question question) async {
    final questionsCollection = Firestore.instance.collection('questions');
    final questionsDocuments = await questionsCollection.where('title', isEqualTo: question.title).get();
    return questionsDocuments.isNotEmpty;
  }

  Future<List<GForm>> getForms() async {
    final formsCollection = Firestore.instance.collection('forms');
    final formDocuments = await formsCollection.get(pageSize: pageSize);
    final forms = <GForm>[];
    for (var doc in formDocuments) {
      forms.add(GForm.fromJson(doc.map));
    }
    return forms;
  }
}