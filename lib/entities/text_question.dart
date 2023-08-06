import 'package:forms_helper/entities/form_item.dart';
import 'package:forms_helper/entities/question_item.dart';

class TextQuestion extends QuestionItem {
  final bool paragraph;

  TextQuestion({
    required super.id,
    required super.title,
    required super.description,
    required super.required,
    required super.pointValue,
    required super.correctAnswers,
    required this.paragraph,
    required super.tag,
  }) : super(questionType: 'textQuestion');


  @override
  Map<String, dynamic> toGoogleFormJson({String index = ''}) {
    final questionJson = super.toGoogleFormJson(index: index);
    questionJson['questionItem']['question']['textQuestion'] = {
      'paragraph': paragraph,
    };
    return questionJson;
  }


  @override
  Map<String, dynamic> toMap() {
    final questionJson = super.toMap();
    questionJson['question']['textQuestion'] = {
      'paragraph': paragraph,
    };
    return questionJson;
  }

  factory TextQuestion.fromGoogleFormJson(Map<String, dynamic> json) {
    bool paragraph =
        json['questionItem']['question']['textQuestion']['paragraph'] ?? false;
    final item = FormItem.fromGoogleFormJson(json);
    final questionItem = QuestionItem.fromGoogleFormJson(json);
    return TextQuestion(
      id: item.id,
        title: item.title,
        description: item.description,
        required: questionItem.required,
        pointValue: questionItem.pointValue,
        correctAnswers: questionItem.correctAnswers,
        paragraph: paragraph,
        tag: questionItem.tag,
    );
  }

  factory TextQuestion.fromMap(Map<String, dynamic> json) {
    bool paragraph = json['question']?['textQuestion']?['paragraph'] ?? false;
    final item = FormItem.fromMap(json);
    final questionItem = QuestionItem.fromMap(json);
    return TextQuestion(
      id: item.id,
      title: item.title,
      description: item.description,
      required: questionItem.required,
      pointValue: questionItem.pointValue,
      correctAnswers: questionItem.correctAnswers,
      paragraph: paragraph,
      tag: questionItem.tag,
    );
  }
}
