import 'package:forms_helper/entities/choice_question.dart';
import 'package:forms_helper/entities/form_item.dart';
import 'package:forms_helper/entities/question_item.dart';
import 'package:forms_helper/entities/text_question.dart';

class GForm {
  final String title;
  final String documentTitle;
  final String description;
  final bool isQuiz = true;
  final List<FormItem>? items;

  GForm({
    required this.title,
    required this.description,
    required this.documentTitle,
    this.items,
  });

  Map<String, dynamic> get baseInfo =>
      {'title': title, 'documentTitle': documentTitle};

  Map<String, dynamic> get info => {
        'title': title,
        'documentTitle': documentTitle,
        'description': description
      };

  factory GForm.fromMap(Map<String, dynamic> json) {
    String title = json['title'] ?? "Untitled";
    String desc = json['description'] ?? "";
    String documentTitle = json['documentTitle'] ?? "Unnamed";
    bool isQuiz = json['isQuiz'] ?? false;
    List<FormItem> items = (json['items'] as Iterable).map((e) {
      final questionItem = QuestionItem.fromMap(e);
      if (questionItem.questionType == 'choiceQuestion') {
        return ChoiceQuestion.fromMap(e);
      } else {
        return TextQuestion.fromMap(e);
      }
    }).toList();
    return GForm(
        title: title,
        description: desc,
        documentTitle: documentTitle,
        items: items);
  }

  factory GForm.fromGoogleFormJson(Map<String, dynamic> json) {
    String title = json['info']['title'] ?? "Untitled";
    String desc = json['info']['description'] ?? "";
    String documentTitle = json['info']['documentTitle'] ?? "Unnamed";
    bool isQuiz = json['settings']['quizSettings']['isQuiz'] ?? false;
    List<FormItem> items = (json['items'] as Iterable).map((e) {
      if (e['questionItem']['question']['choiceQuestion'] != null) {
        return ChoiceQuestion.fromGoogleFormJson(e);
      } else if (e['questionItem']['question']['textQuestion'] != null) {
        return TextQuestion.fromGoogleFormJson(e);
      }
      return TextQuestion.fromGoogleFormJson(e);
    }).toList();
    return GForm(
        title: title,
        description: desc,
        documentTitle: documentTitle,
        items: items);
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'documentTitle': documentTitle,
      'isQuiz': isQuiz,
      'items': items?.map((e) => e.toMap()).toList(),
    };
  }

  Map<String, dynamic> toGoogleFormJson() {
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
      'items': items?.map((e) => e.toGoogleFormJson()).toList(),
    };
  }
}
