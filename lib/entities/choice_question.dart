import 'package:forms_helper/entities/answer.dart';
import 'package:forms_helper/entities/form_item.dart';
import 'package:forms_helper/entities/question_item.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../common/strings.dart';

enum QuestionType { RADIO, CHECKBOX, DROP_DOWN }

class ChoiceQuestion extends QuestionItem {
  final bool shuffle;
  final List<Answer> options;
  final QuestionType type;

  ChoiceQuestion({
    required super.id,
    required super.title,
    required super.description,
    required super.required,
    required this.shuffle,
    required super.pointValue,
    required this.options,
    required super.correctAnswers,
    required this.type,
    required super.tag,
  }) : super(questionType: 'choiceQuestion');

  @override
  Map<String, dynamic> toMap() {
    final questionJson = super.toMap();
    questionJson['question']['choiceQuestion'] = {
      'type': type.name,
      'options': options.map((e) => e.toMap()).toList(),
      'shuffle': shuffle,
    };
    return questionJson;
  }

  @override
  Map<String, dynamic> toGoogleFormJson({String index = ''}) {
    final questionJson = super.toGoogleFormJson(index: index);
    questionJson['questionItem']['question']['choiceQuestion'] = {
      'type': type.name,
      'options': options.map((e) => e.toMap()).toList(),
      'shuffle': shuffle,
    };
    return questionJson;
  }

  factory ChoiceQuestion.fromGoogleFormJson(Map<String, dynamic> json) {
    QuestionType type = QuestionType.values
        .byName(
        json['questionItem']['question']['choiceQuestion']['type'] ?? 'RADIO');
    List<Answer> options = (json['questionItem']['question']['choiceQuestion']
    ['options'] as Iterable)
        .map((e) => Answer(value: e['value']))
        .toList();
    bool shuffle =
        json['questionItem']['question']['choiceQuestion']['shuffle'] ?? false;
    final item = FormItem.fromGoogleFormJson(json);
    final questionItem = QuestionItem.fromGoogleFormJson(json);
    return ChoiceQuestion(
      id: item.id,
      title: item.title,
      description: item.description,
      required: questionItem.required,
      shuffle: shuffle,
      pointValue: questionItem.pointValue,
      options: options,
      correctAnswers: questionItem.correctAnswers,
      type: type,
      tag: questionItem.tag,
    );
  }

  factory ChoiceQuestion.fromMap(Map<String, dynamic> json) {
    QuestionType type = QuestionType.values
        .byName(json['question']['choiceQuestion']['type'] ?? 'RADIO');
    List<Answer> options = (json['question']['choiceQuestion']
    ['options'] as Iterable)
        .map((e) => Answer(value: e['value']))
        .toList();
    bool shuffle =
        json['question']['choiceQuestion']['shuffle'] ?? false;
    final item = FormItem.fromMap(json);
    final questionItem = QuestionItem.fromMap(json);
    return ChoiceQuestion(
      id: item.id,
      title: item.title,
      description: item.description,
      required: questionItem.required,
      shuffle: shuffle,
      pointValue: questionItem.pointValue,
      options: options,
      correctAnswers: questionItem.correctAnswers,
      type: type,
      tag: questionItem.tag,
    );
  }

  String getType() {
    switch (type) {
      case QuestionType.CHECKBOX:
        return Strings.checkbox;
      case QuestionType.DROP_DOWN:
        return Strings.dropdown;
      case QuestionType.RADIO:
        return Strings.radio;
    }
  }
}
