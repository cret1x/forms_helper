import 'package:forms_helper/entities/answer.dart';

class Question {
  final String text;
  final bool required;
  final List<Answer> answers;
  final Answer correct;

  Question({
    required this.text,
    required this.required,
    required this.answers,
    required this.correct,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> res = {};
    res['required'] = required;
    res['choiceQuestion'] = {
      "type": "RADIO",
      "options": answers.map((e) => e.toMap()).toList(),
      "shuffle": true,
    };
    return res;
  }
}
