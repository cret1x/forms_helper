import 'package:forms_helper/entities/answer.dart';

enum QuestionType {RADIO, CHECKBOX, DROP_DOWN}

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
}
