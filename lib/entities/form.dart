import 'package:forms_helper/entities/question.dart';

class GForm {
  final String title;
  final String documentTitle;
  final String description;
  final bool isQuiz = true;
  final List<Question>? questions;

  GForm(
      {required this.title, required this.description, required this.documentTitle, this.questions,});

  Map<String, dynamic> get baseInfo => {'title': title, 'documentTitle': documentTitle};
  Map<String, dynamic> get info => {'title': title, 'documentTitle': documentTitle, 'description': description};
}
