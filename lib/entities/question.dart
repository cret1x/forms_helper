import 'package:forms_helper/entities/answer.dart';

enum QuestionType { RADIO, CHECKBOX, DROP_DOWN }

class Question {
  final String title;
  final String description;
  final bool required;
  final bool shuffle;
  final int pointValue;
  final List<Answer> answers;
  final List<Answer> correctAnswers;
  final QuestionType type;

  Question({
    required this.title,
    required this.description,
    required this.required,
    required this.shuffle,
    required this.pointValue,
    required this.answers,
    required this.correctAnswers,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> questionJson = {
      'title': title,
      'description': description,
      'questionItem': {
        'question': {
          'required': required,
          'grading': {
            'pointValue': pointValue,
            'correctAnswers': {
              'answers': correctAnswers.map((e) => e.toMap()).toList(),
            },
          },
          'choiceQuestion': {
            'type': type.name,
            'options': answers.map((e) => e.toMap()).toList(),
            'shuffle': shuffle,
          },
        },
      },
    };
    return questionJson;
  }

  factory Question.fromJson(Map<String, dynamic> json) {
    String title = json['title'];
    String desc = json['description'];
    bool required = json['questionItem']['question']['required'];
    int pointValue = json['questionItem']['question']['grading']['pointValue'];
    List<Answer> correctAnswers = (json['questionItem']['question']['grading']
            ['correctAnswers']['answers'] as Iterable)
        .map((e) => Answer(value: e['value']))
        .toList();
    QuestionType type = QuestionType.values
        .byName(json['questionItem']['question']['choiceQuestion']['type']);
    List<Answer> answers = (json['questionItem']['question']['choiceQuestion']
            ['options'] as Iterable)
        .map((e) => Answer(value: e['value']))
        .toList();
    bool shuffle =
        json['questionItem']['question']['choiceQuestion']['shuffle'] ?? false;
    return Question(
        title: title,
        description: desc,
        required: required,
        shuffle: shuffle,
        pointValue: pointValue,
        answers: answers,
        correctAnswers: correctAnswers,
        type: type);
  }
}
