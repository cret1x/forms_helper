import 'dart:io';

import 'package:forms_helper/entities/choice_question.dart';
import 'package:forms_helper/entities/question_item.dart';
import 'package:forms_helper/entities/question_tag.dart';
import 'package:forms_helper/entities/text_question.dart';
import 'package:forms_helper/firebase_functions/storage.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class LocalStorage {
  static const databasePath = 'FormsHelper/forms_helper.db';
  static final LocalStorage _localStorage = LocalStorage._internal();
  static const pageSize = 20;

  var questionsCount = 0;
  final _firestoreManager = FirestoreManager();
  bool isInitialized = false;
  final DatabaseFactory _dbFactory = databaseFactoryIo;
  late Database _db;

  factory LocalStorage() {
    return _localStorage;
  }

  LocalStorage._internal();

  int get pages {
    if (questionsCount == 0) {
      return questionsCount;
    }
    double pgs = questionsCount / pageSize;
    return pgs.ceil();
  }

  Future<void> init() async {
    if (isInitialized) {
      return;
    }
    final docPath = (await getApplicationDocumentsDirectory()).path;
    final path = join(docPath, databasePath);
    File dbFile = File(path);
    await dbFile.delete();
    _db = await _dbFactory.openDatabase(path);
    await for (final questions in _firestoreManager.getQuestions()) {
      _importQuestions(questions);
      questionsCount += questions.length;
    }
    isInitialized = true;
  }

  Future<void> update() async {
    if (!isInitialized) {
      return;
    }
    _db.close();
    final docPath = (await getApplicationDocumentsDirectory()).path;
    final path = join(docPath, databasePath);
    File dbFile = File(path);
    await dbFile.delete();
    _db = await _dbFactory.openDatabase(path);
    await for (final questions in _firestoreManager.getQuestions()) {
      _importQuestions(questions);
      questionsCount += questions.length;
    }
  }

  Future<List<QuestionItem>> getQuestions(
      {String? searchText,
      int page = 0,
      bool ascending = true,
      String? tag}) async {
    var store = intMapStoreFactory.store('questions');
    List<QuestionItem> items = [];
    Filter? filter;
    if (searchText != null) {
      var regExp = RegExp(searchText, caseSensitive: false);
      filter = Filter.or([
        Filter.matchesRegExp('title', regExp),
        Filter.matchesRegExp('description', regExp),
      ]);
    }
    if (tag != null && tag.isNotEmpty) {
      var regExp = RegExp(tag, caseSensitive: false);
      var tagFilter = Filter.matchesRegExp('question.tag', regExp);
      if (filter == null) {
        filter = tagFilter;
      } else {
        filter = Filter.and([
          filter,
          tagFilter,
        ]);
      }
    }
    final finder = Finder(
        offset: page * pageSize,
        limit: pageSize,
        filter: filter,
        sortOrders: [SortOrder('title', ascending)]);
    final records = await store.find(_db, finder: finder);
    for (var record in records) {
      if (QuestionItem.fromMap(record.value).questionType == 'choiceQuestion') {
        items.add(ChoiceQuestion.fromMap(record.value));
      } else {
        items.add(TextQuestion.fromMap(record.value));
      }
    }
    return items;
  }

  Future<void> _importQuestions(List<QuestionItem> questions) async {
    final store = intMapStoreFactory.store('questions');
    await _db.transaction((transaction) async {
      await store.addAll(transaction, questions.map((e) => e.toMap()).toList());
    });
  }

  Future<void> saveQuestions(List<QuestionItem> questions) async {
    final store = intMapStoreFactory.store('questions');
    _firestoreManager.saveQuestions(questions);
    await _db.transaction((transaction) async {
      await store.addAll(transaction, questions.map((e) => e.toMap()).toList());
    });
  }

  Future<void> updateQuestion(QuestionItem questionItem) async {
    final store = intMapStoreFactory.store('questions');
    final filter = Filter.equals('title', questionItem.title);
    final finder = Finder(filter: filter);
    await store.update(_db, questionItem.toMap(), finder: finder);
    await _firestoreManager.updateQuestion(questionItem);
  }

  Future<void> deleteQuestion(QuestionItem questionItem) async {
    final store = intMapStoreFactory.store('questions');
    final filter = Filter.equals('title', questionItem.title);
    final finder = Finder(filter: filter);
    await store.delete(_db, finder: finder);
    await _firestoreManager.deleteQuestion(questionItem);
  }

  Future<bool> exists(QuestionItem questionItem) async {
    final store = intMapStoreFactory.store('questions');
    final filter = Filter.equals('title', questionItem.title);
    final finder = Finder(filter: filter);
    final record = await store.findFirst(_db, finder: finder);
    return record != null;
  }

  Future<List<Tag>> getTags() async {
    final store = intMapStoreFactory.store('tags');
    final finder = Finder(
        sortOrders: [SortOrder('value')]);
    final records = await store.find(_db, finder: finder);
    List<Tag> tags = [];
    for (var record in records) {
      tags.add(Tag.fromMap(record.value));
    }
    return tags;
  }

  Future<void> createTag(Tag tag) async {
    final store = intMapStoreFactory.store('tags');
    await store.add(_db, tag.toMap());
  }

  Future<void> deleteTag(Tag tag) async {
    final store = intMapStoreFactory.store('tags');
    final filter = Filter.equals('id', tag.id);
    final finder = Finder(filter: filter);
    await store.delete(_db, finder: finder);
    final qStore = intMapStoreFactory.store('questions');
    final qFilter = Filter.equals('tag.id', tag.id);
    final qFinder = Finder(filter: qFilter);
    await qStore.delete(_db, finder: qFinder);
  }

  Future<void> updateTag(Tag tag) async {
    final store = intMapStoreFactory.store('tags');
    final filter = Filter.equals('id', tag.id);
    final finder = Finder(filter: filter);
    await store.update(_db, tag.toMap(), finder: finder);
  }

  Future<bool> tagExists(Tag tag) async {
    final store = intMapStoreFactory.store('tags');
    final filter = Filter.equals('id', tag.id);
    final finder = Finder(filter: filter);
    final record = await store.findFirst(_db, finder: finder);
    return record != null;
  }
}
