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

  factory GForm.fromJson(Map<String, dynamic> json) {
    String title = json['info']['title'];
    String desc = json['info']['description'] ?? "";
    String documentTitle = json['info']['documentTitle'] ?? "Unnamed";
    bool isQuiz = json['settings']['quizSettings']['isQuiz'] ?? false;
    List<Question> questions = (json['items'] as Iterable).map((e) => Question.fromJson(e)).toList();
    return GForm(title: title, description: desc, documentTitle: documentTitle, questions: questions);
  }

  Map<String, dynamic> toMap() {
    return {
      'info': {
        'title': title,
        'description': description,
        'documentTitle': documentTitle,
      },
      'settings': {
        'quizSettings': {
          'isQuiz': isQuiz,
        },
      },
      'items': questions?.map((e) => e.toMap()).toList(),
    };
  }
}
