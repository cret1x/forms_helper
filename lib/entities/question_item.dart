import 'package:forms_helper/entities/answer.dart';
import 'package:forms_helper/entities/form_item.dart';
import 'package:forms_helper/entities/question_tag.dart';

class QuestionItem extends FormItem {
  final bool required;
  final int pointValue;
  final List<Answer> correctAnswers;
  final String questionType;
  Tag? tag;

  QuestionItem({
    required super.title,
    required super.description,
    required this.required,
    required this.pointValue,
    required this.correctAnswers,
    required this.questionType,
    this.tag,
  });

  @override
  Map<String, dynamic> toMap() {
    final itemJson = super.toMap();
    itemJson['question'] = {
      'required': required,
      'pointValue': pointValue,
      'correctAnswers': correctAnswers.map((e) => e.toMap()).toList(),
      'questionType': questionType,
      'tag': tag?.toMap(),
    };
    return itemJson;
  }

  factory QuestionItem.fromMap(Map<String, dynamic> json) {
    final item = FormItem.fromMap(json);
    bool required = json['question']['required'] ?? false;
    int pointValue = json['question']['pointValue'] ?? 0;
    List<Answer> correctAnswers =
        (json['question']['correctAnswers'] as Iterable)
            .map((e) => Answer(value: e['value']))
            .toList();
    String questionType = json['question']['questionType'] ?? "";
    Tag? tag = json['question']['tag'] != null ? Tag.fromMap(json['question']['tag']) : null;
    return QuestionItem(
      title: item.title,
      description: item.description,
      required: required,
      pointValue: pointValue,
      correctAnswers: correctAnswers,
      questionType: questionType,
      tag: tag,
    );
  }

  @override
  Map<String, dynamic> toGoogleFormJson() {
    final itemJson = super.toGoogleFormJson();
    itemJson['questionItem'] = {
      'question': {
        'required': required,
        if (correctAnswers.isNotEmpty)
          'grading': {
            'pointValue': pointValue,
            'correctAnswers': {
              'answers': correctAnswers.map((e) => e.toMap()).toList(),
            },
          },
      },
    };
    return itemJson;
  }

  factory QuestionItem.fromGoogleFormJson(Map<String, dynamic> json) {
    bool required = json['questionItem']?['question']?['required'] ?? false;
    int pointValue =
        json['questionItem']?['question']?['grading']?['pointValue'] ?? 0;
    late List<Answer> correctAnswers;
    if (json['questionItem']?['question']?['grading']?['correctAnswers'] != null) {
      correctAnswers = (json['questionItem']['question']['grading']
              ['correctAnswers']['answers'] as Iterable)
          .map((e) => Answer(value: e['value']))
          .toList();
    } else {
      correctAnswers = [];
    }
    String questionType = "";
    if (json['questionItem']?['question']['choiceQuestion'] != null) {
      questionType = 'choiceQuestion';
    } else if (json['questionItem']?['question']['textQuestion'] != null) {
      questionType = 'textQuestion';
    }

    final item = FormItem.fromGoogleFormJson(json);
    return QuestionItem(
      title: item.title,
      description: item.description,
      required: required,
      pointValue: pointValue,
      correctAnswers: correctAnswers,
      questionType: questionType,
      tag: null,
    );
  }

  @override
  String toString() {
    return '[$title, $questionType, $pointValue, ${tag?.value}]';
  }
}
