import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forms_helper/entities/question_tag.dart';

class DisciplinesListStateNotifier
    extends StateNotifier<List<Tag>> {
  DisciplinesListStateNotifier() : super([]);

  void addDiscipline(Tag discipline) {
    if (!state.contains(discipline)) {
      state = [...state, discipline];
    }
  }

  void deleteDiscipline(Tag discipline) {
    state = [
      for (final q in state)
        if (discipline != q) q,
    ];
  }
}