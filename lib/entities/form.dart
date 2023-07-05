import 'package:forms_helper/entities/question.dart';

class GForm {
  final String title;
  final String description;
  final String? documentTitle;
  final List<Question>? questions;

  GForm(
      {required this.title, required this.description, this.documentTitle, this.questions,});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> res = {};
    res['info'] = {'title': title};
    //res['items'] = questions?.map((e) => {'title': 'test', 'description': 'test2', 'questionItem': e.toMap()}).toList();
    return res;
  }
}
