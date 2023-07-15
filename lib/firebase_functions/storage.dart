import 'package:firedart/firestore/firestore.dart';
import 'package:firedart/firestore/models.dart';
import 'package:forms_helper/entities/form.dart';
import 'package:forms_helper/entities/choice_question.dart';
import 'package:forms_helper/entities/question_item.dart';
import 'package:forms_helper/entities/text_question.dart';


class QuestionItemPage {
  List<QuestionItem> questions;
  String? nextPageToken;

  QuestionItemPage(this.questions, this.nextPageToken);
}

class FirestoreManager {
  static final FirestoreManager _firestoreManager = FirestoreManager._internal();
  static const int pageSize = 20;
  factory FirestoreManager() {
    return _firestoreManager;
  }
  FirestoreManager._internal();

  Future<QuestionItemPage> _getPage({String? nextPageToken}) async {
    final questionsCollection = Firestore.instance.collection('questions');
    final questions = <QuestionItem>[];
    Page<Document> questionDocuments;
    if (nextPageToken == null) {
      questionDocuments = await questionsCollection.get(pageSize: pageSize);
    } else {
      questionDocuments = await questionsCollection.get(pageSize: pageSize, nextPageToken: nextPageToken);
    }
    for (var doc in questionDocuments) {
      if (QuestionItem.fromMap(doc.map).questionType == 'choiceQuestion') {
        questions.add(ChoiceQuestion.fromMap(doc.map));
      } else {
        questions.add(TextQuestion.fromMap(doc.map));
      }
    }
    if (questionDocuments.length < pageSize) {
      return QuestionItemPage(questions, null);
    } else {
      return QuestionItemPage(questions, questionDocuments.nextPageToken);
    }
  }


  Stream<List<QuestionItem>> getQuestions() async* {
    var page = await _getPage();
    yield page.questions;
    while(page.nextPageToken != null) {
      page = await _getPage();
      yield page.questions;
    }
  }
  
  Future<void> saveQuestions(List<QuestionItem> questions) async {
    final questionsCollection = Firestore.instance.collection('questions');
    for (var question in questions) {
      questionsCollection.add(question.toMap());
    }
  }

  Future<void> saveForm(GForm form) async {
    final formsCollection = Firestore.instance.collection('forms');
    formsCollection.add(form.toMap());
  }

  Future<bool> isQuestionExist(ChoiceQuestion question) async {
    final questionsCollection = Firestore.instance.collection('questions');
    final questionsDocuments = await questionsCollection.where('title', isEqualTo: question.title).get();
    return questionsDocuments.isNotEmpty;
  }

  Future<List<GForm>> getForms() async {
    final formsCollection = Firestore.instance.collection('forms');
    final formDocuments = await formsCollection.get(pageSize: pageSize);
    final forms = <GForm>[];
    for (var doc in formDocuments) {
      forms.add(GForm.fromMap(doc.map));
    }
    return forms;
  }
}