import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entities/question_item.dart';

class SelectionStateNotifier extends StateNotifier<bool> {
  SelectionStateNotifier() : super(false);

  void toggle() {
    state = !state;
  }
}
