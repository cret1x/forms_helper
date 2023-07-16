import 'package:flutter/material.dart';
import 'package:forms_helper/entities/choice_question.dart';

import '../common/strings.dart';
import '../common/themes.dart';
import '../entities/question_item.dart';
import '../entities/text_question.dart';

class QuestionWidget extends StatelessWidget {
  final QuestionItem question;
  final bool? imported;
  final bool? stored;

  const QuestionWidget({
    required this.question,
    this.imported,
    this.stored,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Themes.darkBlue,
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 26,
            horizontal: 28,
          ),
          child: ListView(
            shrinkWrap: true,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    question is ChoiceQuestion
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
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      Strings.back,
                    ),
                  ),
                ],
              ),
              SelectableText(
                question.title,
                style: Theme.of(context).textTheme.headlineLarge,
                minLines: 1,
                maxLines: 18,
              ),
              if (question.description.isNotEmpty)
                const SizedBox(
                  height: 12,
                ),
              if (question.description.isNotEmpty)
                SelectableText(
                  question.description,
                  style: Theme.of(context).textTheme.titleLarge,
                  minLines: 1,
                  maxLines: 18,
                ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(),
              ),
              if (question is ChoiceQuestion)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    Strings.options,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              if (question is ChoiceQuestion)
                Column(
                  children: (question as ChoiceQuestion)
                      .options
                      .map(
                        (e) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: !question.correctAnswers.contains(e)
                              ? Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 1, right: 13),
                                      child: Text(
                                        "-",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                    ),
                                    Text(
                                      e.value,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
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
                                    Text(
                                      e.value,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                  ],
                                ),
                        ),
                      )
                      .toList(),
                ),
              if (question is ChoiceQuestion)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(),
                ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 4,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Strings.discipline,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      question.tag == null || question.tag!.isEmpty
                          ? Strings.no
                          : question.tag!,
                      style: Theme.of(context).textTheme.displaySmall,
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Strings.required,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      question.required ? Strings.yes : Strings.no,
                      style: Theme.of(context).textTheme.displaySmall,
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 4,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Strings.points,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      question.pointValue.toString(),
                      style: Theme.of(context).textTheme.displaySmall,
                    )
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(),
              ),
              if (question is ChoiceQuestion)
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 4,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        Strings.answerType,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        (question as ChoiceQuestion).getType(),
                        style: Theme.of(context).textTheme.displaySmall,
                      )
                    ],
                  ),
                ),
              if (question is ChoiceQuestion)
                Padding(
                  padding: const EdgeInsets.only(
                    top: 4,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        Strings.shuffle,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        (question as ChoiceQuestion).shuffle
                            ? Strings.yes
                            : Strings.no,
                        style: Theme.of(context).textTheme.displaySmall,
                      )
                    ],
                  ),
                ),
              if (question is TextQuestion)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Strings.paragraph,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      (question as TextQuestion).paragraph
                          ? Strings.yes
                          : Strings.no,
                      style: Theme.of(context).textTheme.displaySmall,
                    )
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
