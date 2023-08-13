import 'package:firedart/firestore/firestore.dart';
import 'package:firedart/firestore/models.dart';
import 'package:forms_helper/entities/form.dart';
import 'package:forms_helper/entities/choice_question.dart';
import 'package:forms_helper/entities/question_item.dart';
import 'package:forms_helper/entities/question_tag.dart';
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
    print('getPage called!');
    final questionsCollection = Firestore.instance.collection('questions');
    final questions = <QuestionItem>[];
    Page<Document> questionDocuments;
    if (nextPageToken == null || nextPageToken.isEmpty) {
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
    int requestedPagesCount = 1;
    while(page.nextPageToken != null && page.nextPageToken!.isNotEmpty) {
      requestedPagesCount++;
      print('Next page token: ${page.nextPageToken}');
      page = await _getPage(nextPageToken: page.nextPageToken);
      yield page.questions;
      if (requestedPagesCount > 1000) {
        return;
      }
    }
  }
  
  Future<void> saveQuestions(List<QuestionItem> questions) async {
    final questionsCollection = Firestore.instance.collection('questions');
    for (var question in questions) {
      questionsCollection.add(question.toMap());
    }
  }

  Future<void> deleteQuestion(QuestionItem questionItem) async {
    if (!await exists(questionItem)) {
      return;
    }
    final questionsCollection = Firestore.instance.collection('questions');
    final document = await questionsCollection.where('id', isEqualTo: questionItem.id).get();
    final key = document.first.id;
    final docDef = questionsCollection.document(key);
    await docDef.delete();
  }

  Future<void> updateQuestion(QuestionItem questionItem) async {
    if (!await exists(questionItem)) {
      return;
    }
    final questionsCollection = Firestore.instance.collection('questions');
    final document = await questionsCollection.where('id', isEqualTo: questionItem.id).get();
    final key = document.first.id;
    await questionsCollection.document(key).update(questionItem.toMap());
  }

  Future<bool> exists(QuestionItem question) async {
    final questionsCollection = Firestore.instance.collection('questions');
    final questionsDocuments = await questionsCollection.where('id', isEqualTo: question.id).get();
    return questionsDocuments.isNotEmpty;
  }

  Future<List<Tag>> getTags() async {
    print('getTags called!');
    final tagsCollection = Firestore.instance.collection('tags');
    final documents = await tagsCollection.get();
    List<Tag> tags = [];
    for (var doc in documents) {
      tags.add(Tag.fromMap(doc.map));
    }
    return tags;
  }

  Future<void> createTag(Tag tag) async {
    print(tag.value);
    final tagsCollection = Firestore.instance.collection('tags');
    await tagsCollection.add(tag.toMap());
  }

  Future<void> deleteTag(Tag tag) async {
    if (!await tagExists(tag)) {
      return;
    }
    final tagsCollection = Firestore.instance.collection('tags');
    final document = await tagsCollection.where('id', isEqualTo: tag.id).get();
    final key = document.first.id;
    final docDef = tagsCollection.document(key);
    await docDef.delete();
    final questionsCollection = Firestore.instance.collection('questions');
    final questionsDocs = await questionsCollection.where('tag.id', isEqualTo: tag.id).get();
    for (var doc in questionsDocs) {
      final key = doc.id;
      final qRef = questionsCollection.document(key);
      qRef.delete();
    }
  }

  Future<void> updateTag(Tag tag) async {
    if (!await tagExists(tag)) {
      return;
    }
    final tagsCollection = Firestore.instance.collection('tags');
    final document = await tagsCollection.where('id', isEqualTo: tag.id).get();
    final key = document.first.id;
    await tagsCollection.document(key).update(tag.toMap());
  }

  Future<bool> tagExists(Tag tag) async {
    final tagsCollection = Firestore.instance.collection('tags');
    final documents = await tagsCollection.where('id', isEqualTo: tag.id).get();
    return documents.isNotEmpty;
  }
}