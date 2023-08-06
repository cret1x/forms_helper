import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forms_helper/entities/form.dart';

class ExportStateNotifier extends StateNotifier<GForm?> {
  ExportStateNotifier() : super(null);

  void setForm(GForm form) {
    state = form;
  }
}
