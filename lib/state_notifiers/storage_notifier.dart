import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entities/question_item.dart';

class StorageQuestionsStateNotifier
    extends StateNotifier<List<QuestionItem>> {
  StorageQuestionsStateNotifier() : super([]);

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
}