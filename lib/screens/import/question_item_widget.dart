import 'package:flutter/material.dart';
import 'package:forms_helper/entities/choice_question.dart';
import 'package:forms_helper/screens/import/choice_question_answers.dart';

import '../../common/strings.dart';
import '../../entities/question_item.dart';
import '../../sqlite/local_storage.dart';
import '../question_widget.dart';

class QuestionWidgetInfo {
  bool? contained;
  bool _isSelected = false;
  late final bool _storage;

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
  final LocalStorage _storage = LocalStorage();

  QuestionItemWidget(
      {required this.question, bool fromStorage = false, super.key}) {
    info._storage = fromStorage;
  }

  @override
  State<StatefulWidget> createState() {
    return _QuestionItemWidgetState();
  }
}

class _QuestionItemWidgetState extends State<QuestionItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuestionWidget(
                question: widget.question,
                imported: true,
              ),
            ),
          );
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
                    child: !widget.info._storage
                        ? FutureBuilder(
                            future: widget._storage.exists(widget.question),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return CircularProgressIndicator(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                );
                              }
                              return snapshot.data! && !widget.info._storage
                                  ? const Icon(Icons.download_done)
                                  : Checkbox(
                                      value: widget.info.selected,
                                      onChanged: (_) {
                                        setState(() {
                                          widget.info._toggle();
                                        });
                                      },
                                    );
                            },
                          )
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
