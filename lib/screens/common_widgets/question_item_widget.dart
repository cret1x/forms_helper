import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forms_helper/entities/choice_question.dart';
import 'package:forms_helper/screens/construct.dart';
import 'package:forms_helper/screens/common_widgets/choice_question_answers.dart';
import 'package:forms_helper/screens/storage/storage.dart';

import '../../common/strings.dart';
import '../../entities/question_item.dart';
import '../../global_providers.dart';
import '../../sqlite/local_storage.dart';
import 'question_widget.dart';

class QuestionWidgetInfo {
  bool _isSelected = false;
  late final bool _fromImportScreen;
  late final bool _fromStorageScreen;

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

class QuestionItemWidget extends ConsumerStatefulWidget {
  final QuestionItem question;
  final QuestionWidgetInfo info = QuestionWidgetInfo();
  final LocalStorage _storage = LocalStorage();
  final bool noPadding;

  QuestionItemWidget({
    required this.question,
    bool fromImportScreen = false,
    bool fromStorageScreen = false,
    this.noPadding = false,
    super.key,
  }) {
    info._fromImportScreen = fromImportScreen;
    info._fromStorageScreen = fromStorageScreen;
  }

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _QuestionItemWidgetState();
  }
}

class _QuestionItemWidgetState extends ConsumerState<QuestionItemWidget> {
  late List<QuestionItem> _constructQuestions;

  @override
  Widget build(BuildContext context) {
    ref.listen(saveNotifierProvider, (previous, next) {
      setState(() {});
    });
    if (widget.info._fromImportScreen) {
      ref.listen(importSelectionProvider, (previous, next) {
        setState(() {
          widget.info._isSelected = next;
        });
      });
    } else if (!widget.info._fromStorageScreen) {
      ref.listen(constructorSelectionProvider, (previous, next) {
        widget.info._isSelected = next;
        if (widget.info.selected) {
          ref
              .read(constructorSelectedProvider.notifier)
              .addQuestion(widget.question);
        } else {
          ref
              .read(constructorSelectedProvider.notifier)
              .deleteQuestion(widget.question);
        }
        setState(() {});
      });
    }
    if (widget.info._fromStorageScreen) {
      _constructQuestions = ref.watch(constructorQuestionsProvider);
    }
    return Padding(
      padding: EdgeInsets.only(bottom: (widget.noPadding ? 0 : 10)),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuestionWidget(
                question: widget.question,
                imported: widget.info._fromImportScreen,
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
                    child: widget.info._fromImportScreen
                        ? FutureBuilder(
                            future: widget._storage.exists(widget.question),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return CircularProgressIndicator(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                );
                              }
                              return snapshot.data!
                                  ? const Checkbox(
                                      value: true,
                                      onChanged: null,
                                    )
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
                        : widget.info._fromStorageScreen
                            ? !_constructQuestions.contains(widget.question)
                                ? Checkbox(
                                    value: widget.info.selected,
                                    onChanged: (_) {
                                      setState(() {
                                        if (!widget.info.selected) {
                                          ref
                                              .read(storageProvider.notifier)
                                              .addQuestion(widget.question);
                                        } else {
                                          ref
                                              .read(storageProvider.notifier)
                                              .deleteQuestion(widget.question);
                                        }
                                        widget.info._toggle();
                                      });
                                    },
                                  )
                                : const Checkbox(
                                    value: true,
                                    onChanged: null,
                                  )
                            : Checkbox(
                                value: widget.info.selected,
                                onChanged: (_) {
                                  setState(() {
                                    widget.info._toggle();
                                    if (widget.info.selected) {
                                      ref
                                          .read(constructorSelectedProvider
                                              .notifier)
                                          .addQuestion(widget.question);
                                    } else {
                                      ref
                                          .read(constructorSelectedProvider
                                              .notifier)
                                          .deleteQuestion(widget.question);
                                    }
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
