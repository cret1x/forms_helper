import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entities/question_item.dart';

class ConstructorQuestionsStateNotifier
    extends StateNotifier<List<QuestionItem>> {
  ConstructorQuestionsStateNotifier() : super([]);

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
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    newList.insert(newIndex, q);
    state = newList;
  }
}