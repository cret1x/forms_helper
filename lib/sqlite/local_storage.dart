import 'package:forms_helper/entities/choice_question.dart';
import 'package:forms_helper/entities/question_item.dart';
import 'package:forms_helper/entities/text_question.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class LocalStorage {
  static const databasePath = 'FormsHelper/forms_helper.db';
  static final LocalStorage _localStorage = LocalStorage._internal();
  static const pageSize = 20;
  bool isInitialized = false;
  DatabaseFactory dbFactory = databaseFactoryIo;
  late Database db;

  factory LocalStorage() {
    return _localStorage;
  }

  LocalStorage._internal();

  Future<void> init() async {
    final docPath = (await getApplicationDocumentsDirectory()).path;
    db = await dbFactory.openDatabase(join(docPath, databasePath));
    isInitialized = true;
  }

  Future<List<QuestionItem>> getQuestions(
      {String? searchText,
      int page = 0,
      bool ascending = true,
      String? tag}) async {
    var store = intMapStoreFactory.store();
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
    var finder = Finder(
        offset: page * pageSize,
        limit: pageSize,
        filter: filter,
        sortOrders: [SortOrder('title', ascending)]);
    var records = await store.find(db, finder: finder);
    for (var record in records) {
      if (record.value['questionType'] == 'choiceQuestion') {
        items.add(ChoiceQuestion.fromMap(record.value));
      } else {
        items.add(TextQuestion.fromMap(record.value));
      }
    }
    return items;
  }

  Future<void> saveQuestions(List<QuestionItem> questions) async {
    var store = intMapStoreFactory.store();
    await db.transaction((transaction) async {
      await store.addAll(transaction, questions.map((e) => e.toMap()).toList());
    });
  }
}
