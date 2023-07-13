import 'package:forms_helper/entities/answer.dart';
import 'package:forms_helper/entities/form_item.dart';

class QuestionItem extends FormItem {
  final bool required;
  final int pointValue;
  final List<Answer> correctAnswers;

  QuestionItem({
    required super.title,
    required super.description,
    required this.required,
    required this.pointValue,
    required this.correctAnswers,
  });

  @override
  Map<String, dynamic> toMap() {
    final itemJson = super.toMap();
    itemJson['questionItem'] = {
      {
        'question': {
          'required': required,
          'grading': {
            'pointValue': pointValue,
            'correctAnswers': {
              'answers': correctAnswers.map((e) => e.toMap()).toList(),
            },
          },
        }
      }
    };
    return itemJson;
  }

  factory QuestionItem.fromMap(Map<String, dynamic> json) {
    bool required = json['questionItem']['question']['required'] ?? false;
    int pointValue =
        json['questionItem']['question']['grading']['pointValue'] ?? 0;
    List<Answer> correctAnswers = (json['questionItem']['question']['grading']
            ['correctAnswers']['answers'] as Iterable)
        .map((e) => Answer(value: e['value']))
        .toList();
    final item = FormItem.fromMap(json);
    return QuestionItem(
      title: item.title,
      description: item.description,
      required: required,
      pointValue: pointValue,
      correctAnswers: correctAnswers,
    );
  }
}
