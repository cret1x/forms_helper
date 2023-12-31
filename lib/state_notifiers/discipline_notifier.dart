import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forms_helper/entities/question_tag.dart';
import 'package:forms_helper/sqlite/local_storage.dart';

class DisciplinesListStateNotifier
    extends StateNotifier<List<Tag>> {
  DisciplinesListStateNotifier() : super([]);
  final LocalStorage _storage = LocalStorage();

  void init() async {
    if (!_storage.isInitialized) {
      await _storage.init();
    }
    state = await _storage.getTags();
  }

  void addDiscipline(Tag discipline) async {
    if (!state.contains(discipline)) {
      state = [...state, discipline];
      await _storage.createTag(discipline);
    }
  }

  void deleteDiscipline(Tag discipline) async {
    state = [
      for (final q in state)
        if (discipline != q) q,
    ];
    await _storage.deleteTag(discipline);
  }
}