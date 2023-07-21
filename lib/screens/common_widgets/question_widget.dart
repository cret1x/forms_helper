import 'package:flutter/material.dart';
import 'package:forms_helper/entities/choice_question.dart';

import '../../common/strings.dart';
import '../../common/themes.dart';
import '../../entities/question_item.dart';
import '../../entities/text_question.dart';

class QuestionWidget extends StatefulWidget {
  final QuestionItem question;
  final bool imported;

  const QuestionWidget({
    super.key,
    required this.question,
    this.imported = false,
  });

  @override
  State<StatefulWidget> createState() {
    return _QuestionWidgetState();
  }
}

class _QuestionWidgetState extends State<QuestionWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    widget.question is ChoiceQuestion
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
                  Row(
                    children: [
                      if (!widget.imported)
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text(
                            Strings.edit,
                          ),
                        ),
                      if (!widget.imported)
                        const SizedBox(
                          width: 12,
                        ),
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
              SelectableText(
                widget.question.title,
                style: Theme.of(context).textTheme.headlineLarge,
                minLines: 1,
                maxLines: 18,
              ),
              if (widget.question.description.isNotEmpty)
                const SizedBox(
                  height: 12,
                ),
              if (widget.question.description.isNotEmpty)
                SelectableText(
                  widget.question.description,
                  style: Theme.of(context).textTheme.titleLarge,
                  minLines: 1,
                  maxLines: 18,
                ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(),
              ),
              if (widget.question is ChoiceQuestion)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    Strings.options,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              if (widget.question is ChoiceQuestion)
                Column(
                  children: (widget.question as ChoiceQuestion)
                      .options
                      .map(
                        (e) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: !widget.question.correctAnswers.contains(e)
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
              if (widget.question is ChoiceQuestion)
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
                      widget.question.tag == null
                          ? Strings.no
                          : widget.question.tag!.value,
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
                      widget.question.required ? Strings.yes : Strings.no,
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
                      widget.question.pointValue.toString(),
                      style: Theme.of(context).textTheme.displaySmall,
                    )
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(),
              ),
              if (widget.question is ChoiceQuestion)
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
                        (widget.question as ChoiceQuestion).getType(),
                        style: Theme.of(context).textTheme.displaySmall,
                      )
                    ],
                  ),
                ),
              if (widget.question is ChoiceQuestion)
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
                        (widget.question as ChoiceQuestion).shuffle
                            ? Strings.yes
                            : Strings.no,
                        style: Theme.of(context).textTheme.displaySmall,
                      )
                    ],
                  ),
                ),
              if (widget.question is TextQuestion)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Strings.paragraph,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      (widget.question as TextQuestion).paragraph
                          ? Strings.yes
                          : Strings.no,
                      style: Theme.of(context).textTheme.displaySmall,
                    )
                  ],
                ),
            ],
          ),
        ),
    );
  }
}
