import 'package:flutter/material.dart';

import '../entities/form.dart';

class FormMoveNotifier with ChangeNotifier {
  GForm? _form;

  set form(GForm form) {
    _form = form;
  }

  GForm get form {
    return _form!;
  }

  bool get empty {
    return _form == null;
  }

  void clear() {
    _form = null;
  }

  void notify() {
    notifyListeners();
  }
}