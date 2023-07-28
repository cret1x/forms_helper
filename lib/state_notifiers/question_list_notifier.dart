import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forms_helper/sqlite/local_storage.dart';
import 'package:uuid/uuid.dart';

import '../entities/question_item.dart';

class QuestionsStateNotifier
    extends StateNotifier<List<QuestionItem>> {
  QuestionsStateNotifier() : super([]);
  final LocalStorage _storage = LocalStorage();

  void addQuestion(QuestionItem questionItem) {
    if (!state.contains(questionItem)) {
      state = [...state, questionItem];
    }
  }

  void deleteQuestion(QuestionItem questionItem) {
    state = [
      for (final q in state)
        if (questionItem != q) q,
    ];
  }

  void moveQuestion(int oldIndex, int newIndex) {
    List<QuestionItem> newList = [];
    for (var q in state) {
      newList.add(q);
    }
    var q = newList.removeAt(oldIndex);
    newList.insert(newIndex, q);
    state = newList;
  }

  void updateQuestion(QuestionItem questionItem) async {
    await _storage.updateQuestion(questionItem);
    if (state.where((element) => element.id == questionItem.id).isNotEmpty) {
      List<QuestionItem> newList = [];
      for (var q in state) {
        if (q.id == questionItem.id) {
          newList.add(questionItem);
        } else {
          newList.add(q);
        }
      }
      state = newList;
    }
  }
  
  void setQuestions(List<QuestionItem> questions) {
    Uuid uuid  = const Uuid();
    for (var question in questions) {
      if (question.id.isEmpty) {
        question.id = uuid.v1();
      }
    }
    state = [...questions];
  }

  void clear() {
    state = [];
  }
}