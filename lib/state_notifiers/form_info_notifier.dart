import 'package:flutter/material.dart';

import '../entities/form.dart';

class FormInfoNotifier with ChangeNotifier {
  TextEditingController filenameController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  bool get empty {
    return filenameController.text.isEmpty &&
        titleController.text.isEmpty &&
        descriptionController.text.isEmpty;
  }

  void clear() {
    filenameController.text = "";
    titleController.text = "";
    descriptionController.text = "";
  }

  void import(GForm form) {
    filenameController.text = form.documentTitle;
    titleController.text = form.title;
    descriptionController.text = form.description;
  }
}
