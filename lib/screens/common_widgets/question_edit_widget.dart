import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forms_helper/entities/answer.dart';
import 'package:forms_helper/entities/choice_question.dart';
import 'package:forms_helper/entities/text_question.dart';
import 'package:forms_helper/global_providers.dart';
import 'package:forms_helper/sqlite/local_storage.dart';
import 'package:reorderables/reorderables.dart';
import 'package:uuid/uuid.dart';

import '../../common/strings.dart';
import '../../entities/question_item.dart';
import '../../entities/question_tag.dart';
import '../../entities/choice_question.dart';

class QuestionEditWidget extends ConsumerStatefulWidget {
  final QuestionItem? question;

  const QuestionEditWidget({this.question, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _QuestionEditWidgetState();
  }
}

class _AnswerInfo {
  bool selected;
  TextEditingController controller = TextEditingController();

  _AnswerInfo({this.selected = false, String? text}) {
    if (text != null) {
      controller.text = text;
    }
  }
}

class _QuestionEditWidgetState extends ConsumerState<QuestionEditWidget> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  Tag? _dropdownValue;
  String? _type;
  final _nullTag = Tag(id: "", value: "Не выбрано");
  List<Tag>? _disciplines;
  bool _required = false;
  bool _paragraph = false;
  int _points = 1;
  String? _choiceType;
  List<_AnswerInfo> _answers = [];
  bool _shuffle = false;
  final Uuid _uuid = Uuid();

  @override
  void initState() {
    super.initState();
    if (widget.question != null) {
      _titleController.text = widget.question!.title;
      _descriptionController.text = widget.question!.description;
      if (widget.question!.tag != null) {
        _dropdownValue = widget.question!.tag;
      }
      _required = widget.question!.required;
      if (widget.question! is ChoiceQuestion) {
        _type = Strings.choiceQuestion;
        _shuffle = (widget.question as ChoiceQuestion).shuffle;
        _answers = (widget.question as ChoiceQuestion)
            .options
            .map(
              (e) => _AnswerInfo(
                  selected: (widget.question as ChoiceQuestion)
                      .correctAnswers
                      .contains(e),
                  text: e.value),
            )
            .toList();
        switch ((widget.question as ChoiceQuestion).type) {
          case QuestionType.RADIO:
            _choiceType = Strings.radio;
            break;
          case QuestionType.DROP_DOWN:
            _choiceType = Strings.dropdown;
            break;
          case QuestionType.CHECKBOX:
            _choiceType = Strings.checkbox;
            break;
        }
      } else {
        _type = Strings.textQuestion;
        _paragraph = (widget.question as TextQuestion).paragraph;
      }
    }
    _dropdownValue ??= _nullTag;
    _type ??= Strings.choiceQuestion;
    _choiceType ??= Strings.radio;
  }

  @override
  Widget build(BuildContext context) {
    _disciplines = ref.read(disciplinesProvider);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 26,
          horizontal: 28,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.question == null
                  ? Strings.createQuestion
                  : Strings.editQuestion,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          TextField(
                            onChanged: (_) {
                              setState(() {});
                            },
                            controller: _titleController,
                            cursorColor:
                                Theme.of(context).colorScheme.onPrimary,
                            decoration: InputDecoration(
                              hintText: Strings.header,
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .color!
                                        .withOpacity(0.4),
                                  ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              filled: true,
                              contentPadding: const EdgeInsets.all(16),
                            ),
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          TextFormField(
                            controller: _descriptionController,
                            cursorColor:
                                Theme.of(context).colorScheme.onPrimary,
                            maxLines: 6,
                            decoration: InputDecoration(
                              hintText: Strings.description,
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .color!
                                        .withOpacity(0.4),
                                  ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              filled: true,
                              contentPadding: const EdgeInsets.all(16),
                            ),
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          DropdownButtonFormField<String>(
                            borderRadius: BorderRadius.circular(15),
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(16),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              filled: true,
                            ),
                            value: _type,
                            onChanged: (String? newValue) {
                              setState(() {
                                _type = newValue!;
                              });
                            },
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: [
                              Strings.choiceQuestion,
                              Strings.textQuestion
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          DropdownButtonFormField<Tag>(
                            borderRadius: BorderRadius.circular(15),
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(16),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              filled: true,
                            ),
                            value: _dropdownValue,
                            onChanged: (Tag? newValue) {
                              setState(() {
                                _dropdownValue = newValue!;
                              });
                            },
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: [_nullTag, ..._disciplines!]
                                .map<DropdownMenuItem<Tag>>((Tag value) {
                              return DropdownMenuItem<Tag>(
                                value: value,
                                child: Text(value.value),
                              );
                            }).toList(),
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                Strings.required,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Checkbox(
                                  value: _required,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _required = value!;
                                    });
                                  })
                            ],
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                Strings.points,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: _points == 0
                                        ? null
                                        : () {
                                            setState(() {
                                              --_points;
                                            });
                                          },
                                    child: const Icon(Icons.remove),
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  ElevatedButton(
                                    onPressed: null,
                                    child: Text(
                                      _points.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        ++_points;
                                      });
                                    },
                                    child: const Icon(Icons.add),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: const ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                        Colors.redAccent),
                                  ),
                                  onPressed: () async {
                                    bool? result = await showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        actionsPadding: EdgeInsets.all(12),
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(15),
                                          ),
                                        ),
                                        title: const Text(
                                          Strings.discard,
                                          style: TextStyle(
                                            fontFamily: 'Verdana',
                                          ),
                                        ),
                                        content: Text(
                                          Strings.cantRedo,
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context, true);
                                            },
                                            child: const Text(Strings.yes),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context, false);
                                            },
                                            child: const Text(Strings.no),
                                          ),
                                        ],
                                      ),
                                    );
                                    if (result != null && result == true) {
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: const Text(
                                    Strings.cancel,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 24,
                              ),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _titleController.text.isEmpty ? null : () async {
                                    QuestionItem question;
                                    String id = widget.question == null
                                        ? _uuid.v1()
                                        : widget.question!.id;
                                    if (_type == Strings.choiceQuestion) {
                                      List<Answer> answers = [];
                                      List<Answer> correctAnswers = [];
                                      for (var a in _answers) {
                                        final answer =
                                            Answer(value: a.controller.text);
                                        answers.add(answer);
                                        if (a.selected) {
                                          correctAnswers.add(answer);
                                        }
                                      }
                                      QuestionType type;
                                      switch (_choiceType) {
                                        case Strings.radio:
                                          type = QuestionType.RADIO;
                                          break;
                                        case Strings.checkbox:
                                          type = QuestionType.CHECKBOX;
                                          break;
                                        default:
                                          type = QuestionType.DROP_DOWN;
                                          break;
                                      }
                                      question = ChoiceQuestion(
                                        id: id,
                                        title: _titleController.text,
                                        description:
                                            _descriptionController.text,
                                        required: _required,
                                        shuffle: _shuffle,
                                        pointValue: _points,
                                        options: answers,
                                        correctAnswers: correctAnswers,
                                        type: type,
                                        tag: _dropdownValue,
                                      );
                                    } else {
                                      question = TextQuestion(
                                        id: id,
                                        title: _titleController.text,
                                        description:
                                            _descriptionController.text,
                                        required: _required,
                                        pointValue: _points,
                                        // TODO: add correct answers
                                        correctAnswers: [],
                                        paragraph: _paragraph,
                                        tag: _dropdownValue,
                                      );
                                    }
                                    if (widget.question == null) {
                                      await LocalStorage().saveQuestions([question]);
                                    } else {
                                      ref.read(constructorSelectedProvider.notifier).deleteQuestion(widget.question!);
                                      ref.read(constructorQuestionsProvider.notifier).updateQuestion(question);
                                      ref.read(constructorSelectedProvider.notifier).addQuestion(question);
                                    }
                                    Navigator.pop(context, question);
                                  },
                                  child: const Text(
                                    Strings.save,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      child: VerticalDivider(
                        thickness: 1,
                      ),
                    ),
                    Expanded(
                      child: _type == Strings.choiceQuestion
                          ? ReorderableColumn(
                              header: Column(
                                children: [
                                  DropdownButtonFormField<String>(
                                    borderRadius: BorderRadius.circular(15),
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.all(16),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(15),
                                        ),
                                      ),
                                      filled: true,
                                    ),
                                    value: _choiceType,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _choiceType = newValue!;
                                      });
                                    },
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    items: [
                                      Strings.radio,
                                      Strings.dropdown,
                                      Strings.checkbox,
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                  const SizedBox(
                                    height: 24,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        Strings.shuffle,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      Checkbox(
                                        value: _shuffle,
                                        onChanged: (_) {
                                          setState(() {
                                            _shuffle = !_shuffle;
                                          });
                                        },
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 24,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        Strings.ansOptions,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            _answers.add(
                                              _AnswerInfo(),
                                            );
                                          });
                                        },
                                        child: const Text(Strings.add),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                ],
                              ),
                              onReorder: (int oldIndex, int newIndex) {
                                var q = _answers.removeAt(oldIndex);
                                _answers.insert(newIndex, q);
                                setState(() {});
                              },
                              children: _answers
                                  .map(
                                    (e) => Padding(
                                      key: UniqueKey(),
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: e.selected,
                                            onChanged: (value) {
                                              setState(() {
                                                e.selected = value!;
                                              });
                                            },
                                          ),
                                          Expanded(
                                            child: TextField(
                                              controller: e.controller,
                                              cursorColor: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                              decoration: InputDecoration(
                                                hintText: Strings.answer,
                                                hintStyle: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium!
                                                    .copyWith(
                                                      color: Theme.of(context)
                                                          .textTheme
                                                          .titleMedium!
                                                          .color!
                                                          .withOpacity(0.4),
                                                    ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  borderSide: const BorderSide(
                                                    width: 0,
                                                    style: BorderStyle.none,
                                                  ),
                                                ),
                                                filled: true,
                                                contentPadding:
                                                    const EdgeInsets.all(16),
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              //TODO: confirmation
                                              setState(() {
                                                _answers.remove(e);
                                              });
                                            },
                                            icon: const Icon(
                                              Icons.delete_outline,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList(),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        Strings.paragraph,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      Checkbox(
                                        value: _paragraph,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            _paragraph = value!;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
