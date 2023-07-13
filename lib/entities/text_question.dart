import 'package:forms_helper/entities/form_item.dart';
import 'package:forms_helper/entities/question_item.dart';

class TextQuestion extends QuestionItem {
  final bool paragraph;

  TextQuestion({
    required super.title,
    required super.description,
    required super.required,
    required super.pointValue,
    required super.correctAnswers,
    required this.paragraph,
  });

  @override
  Map<String, dynamic> toMap() {
    final questionJson = super.toMap();
    questionJson['textQuestion'] = {
      'paragraph': paragraph,
    };
    return questionJson;
  }

  factory TextQuestion.fromMap(Map<String, dynamic> json) {
    bool paragraph =
        json['questionItem']['question']['textQuestion']['paragraph'] ?? false;
    final item = FormItem.fromMap(json);
    final questionItem = QuestionItem.fromMap(json);
    return TextQuestion(
        title: item.title,
        description: item.description,
        required: questionItem.required,
        pointValue: questionItem.pointValue,
        correctAnswers: questionItem.correctAnswers,
        paragraph: paragraph);
  }
}
