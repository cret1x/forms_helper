import 'package:flutter/material.dart';
import 'package:forms_helper/entities/question.dart';

class QuestionWidget extends StatefulWidget {
  final Question _question;
  const QuestionWidget(this._question, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _QuestionWidgetState();
  }
}

class _QuestionWidgetState extends State<QuestionWidget> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}