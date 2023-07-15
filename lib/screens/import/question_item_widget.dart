import 'package:flutter/material.dart';
import 'package:forms_helper/entities/choice_question.dart';
import 'package:forms_helper/screens/import/choice_question_answers.dart';

import '../../common/strings.dart';
import '../../entities/question_item.dart';
import '../question_widget.dart';

class QuestionWidgetInfo {
  late final bool contained = false;
  bool _isSelected = false;

  bool get selected {
    return _isSelected;
  }

  void _toggle() {
    _isSelected = !_isSelected;
  }

  void select() {
    _isSelected = true;
  }

  void unselect() {
    _isSelected = false;
  }
}

class QuestionItemWidget extends StatefulWidget {
  final QuestionItem question;
  final QuestionWidgetInfo info = QuestionWidgetInfo();

  QuestionItemWidget(this.question, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _QuestionItemWidgetState();
  }
}

class _QuestionItemWidgetState extends State<QuestionItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => QuestionWidget(widget.question)));
        },
        style: ButtonStyle(
          fixedSize: const MaterialStatePropertyAll(Size.infinite),
          backgroundColor: MaterialStatePropertyAll(
              Theme.of(context).colorScheme.background),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(6, 14, 0, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: widget.info.contained
                        ? const Icon(Icons.download_done)
                        : Checkbox(
                            value: widget.info.selected,
                            onChanged: (_) {
                              setState(() {
                                widget.info._toggle();
                              });
                            },
                          ),
                  )
                ],
              ),
              Text(
                widget.question.title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              if (widget.question.description.isNotEmpty)
                Text(
                  widget.question.description,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              if (widget.question is ChoiceQuestion)
                ChoiceQuestionAnswersWidget(widget.question as ChoiceQuestion),
            ],
          ),
        ),
      ),
    );
  }
}
