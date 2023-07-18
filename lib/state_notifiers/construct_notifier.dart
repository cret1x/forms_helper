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

  void moveQuestion(QuestionItem questionItem, int newIndex) {
    int index = 0;
    List<QuestionItem> newList = [];
    for (var q in state) {
      if (index == newIndex) {
        newList.add(questionItem);
        ++index;
      } else if (q != questionItem) {
        newList.add(q);
        ++index;
      }
    }
    state = newList;
  }
}