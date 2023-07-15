import 'package:flutter/material.dart';
import 'package:forms_helper/entities/choice_question.dart';

import '../common/strings.dart';
import '../common/themes.dart';
import '../entities/question_item.dart';

class QuestionWidget extends StatelessWidget {
  final QuestionItem _question;

  const QuestionWidget(this._question, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Themes.darkBlue,
      home: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 26,
          horizontal: 28,
        ),
        child: ListView(
          children: [
            Text(
              _question is ChoiceQuestion
                  ? Strings.choiceQuestion
                  : Strings.textQuestion,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .color!
                        .withOpacity(0.6),
                  ),
            ),
            const SizedBox(
              height: 12,
            ),
            SelectableText(
              _question.title,
              style: Theme.of(context).textTheme.headlineLarge,
              minLines: 1,
              maxLines: 18,
            ),
            const SizedBox(
              height: 12,
            ),
            SelectableText(
              _question.description,
              style: Theme.of(context).textTheme.titleLarge,
              minLines: 1,
              maxLines: 18,
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    Strings.back,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
