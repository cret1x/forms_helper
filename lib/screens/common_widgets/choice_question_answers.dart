import 'package:flutter/material.dart';
import 'package:forms_helper/screens/common_widgets/question_item_widget.dart';

import '../../entities/choice_question.dart';

class ChoiceQuestionAnswersWidget extends StatelessWidget {
  final ChoiceQuestion _question;

  const ChoiceQuestionAnswersWidget(this._question, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Divider(),
        ),
        Column(
          children: _question.options
              .map(
                (e) => Padding(
              padding: const EdgeInsets.only(top: 4),
              child: !_question.correctAnswers.contains(e)
                  ? Row(
                children: [
                  Padding(
                    padding:
                    const EdgeInsets.only(left: 1, right: 13),
                    child: Text(
                      "-",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      e.value,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ],
              )
                  : Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(
                      "✓",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Colors.green),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      e.value,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
            ),
          )
              .toList(),
        )
      ],
    );
  }
}

