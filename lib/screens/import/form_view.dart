import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forms_helper/entities/choice_question.dart';
import 'package:forms_helper/global_providers.dart';
import 'package:forms_helper/screens/common_widgets/question_item_widget.dart';
import 'package:forms_helper/screens/import/no_discipline_selected_dialog.dart';
import 'package:forms_helper/sqlite/local_storage.dart';

import '../../common/strings.dart';
import '../../entities/form.dart';
import '../../entities/question_item.dart';
import '../../entities/question_tag.dart';

class FormView extends ConsumerStatefulWidget {
  final GForm form;
  final PageController pageController;
  final SideMenuController menuController;

  const FormView(
      {required this.form,
      required this.pageController,
      required this.menuController,
      super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _FormViewState();
  }
}

class _FormViewState extends ConsumerState<FormView> {
  List<QuestionItemWidget>? _qWidgets;
  final LocalStorage _storage = LocalStorage();
  final Tag _nullTag = Tag(id: "", value: Strings.notSelected);
  List<Tag>? _disciplines;
  Tag? _dropdownValue;

  @override
  Widget build(BuildContext context) {
    _dropdownValue ??= _nullTag;
    _qWidgets ??= widget.form.items!
        .whereType<QuestionItem>()
        .map(
          (e) => QuestionItemWidget(
            question: e,
            fromImportScreen: true,
          ),
        )
        .toList();
    _disciplines = ref.watch(disciplinesProvider);
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 35,
            child: ListView(
              shrinkWrap: true,
              children: [
                const SizedBox(
                  height: 11,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Strings.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(
                      width: 36,
                    ),
                    Expanded(
                      child: SelectableText(
                        widget.form.documentTitle,
                        style: Theme.of(context).textTheme.displaySmall,
                        minLines: 1,
                        maxLines: 18,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Strings.header,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(
                      width: 36,
                    ),
                    Expanded(
                      child: SelectableText(
                        widget.form.title,
                        style: Theme.of(context).textTheme.displaySmall,
                        minLines: 1,
                        maxLines: 18,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Strings.description,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(
                      width: 36,
                    ),
                    Expanded(
                      child: SelectableText(
                        widget.form.description,
                        style: Theme.of(context).textTheme.displaySmall,
                        minLines: 1,
                        maxLines: 18,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Strings.quiz,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(
                      width: 36,
                    ),
                    Expanded(
                      child: Text(
                        widget.form.isQuiz ? Strings.yes : Strings.no,
                        style: Theme.of(context).textTheme.displaySmall,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        Strings.discipline,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    const SizedBox(
                      width: 36,
                    ),
                    Flexible(
                      child: DropdownButtonFormField<Tag>(
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
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text(Strings.export),
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          bool? res = await showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                actionsPadding: const EdgeInsets.all(12),
                                title: const Text(
                                  Strings.transfer,
                                ),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                                content: Text(
                                  Strings.transferQuestions,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(Strings.cancel),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, true);
                                    },
                                    child: const Text(Strings.all),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, false);
                                    },
                                    child: const Text(Strings.onlySelected),
                                  ),
                                ],
                              );
                            },
                          );
                          List<QuestionItem> questions;
                          if (res == null) {
                            return;
                          } else if (res) {
                            questions = widget.form.items!
                                .whereType<QuestionItem>()
                                .toList();
                          } else {
                            questions = _qWidgets!
                                .where((element) => element.info.selected)
                                .map((e) => e.question)
                                .toList();
                          }
                          widget.pageController.jumpToPage(2);
                          widget.menuController.changePage(2);

                          if (!ref.read(formInfoProvider.notifier).empty ||
                              ref.read(constructorQuestionsProvider).isNotEmpty) {
                            res = await showDialog(
                              builder: (context) {
                                return AlertDialog(
                                  actionsPadding: const EdgeInsets.all(12),
                                  title: const Text(
                                    Strings.notEmpty,
                                  ),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15),
                                    ),
                                  ),
                                  content: Text(
                                    Strings.sureClear,
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text(Strings.cancel),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context, true);
                                      },
                                      child: const Text(Strings.replace),
                                    ),
                                  ],
                                );
                              },
                              context: context,
                            );
                          }

                          if (res == null) {
                            return;
                          }

                          ref.read(formInfoProvider).import(widget.form);
                          ref
                              .read(constructorQuestionsProvider.notifier)
                              .setQuestions(questions);
                        },
                        child: const Text(Strings.toConstructor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 36,
          ),
          Expanded(
            flex: 65,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Strings.questions,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            ref.read(importSelectionProvider.notifier).toggle();
                            setState(() {});
                          },
                          child: Text(
                            ref.read(importSelectionProvider)
                                ? Strings.unselectAll
                                : Strings.selectAll,
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (_qWidgets!.every((e) => !e.info.selected)) {
                              await showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  actionsPadding: const EdgeInsets.all(12),
                                  title: const Text(
                                    Strings.noQuestionsSelected,
                                    style: TextStyle(
                                      fontFamily: 'Verdana',
                                    ),
                                  ),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15),
                                    ),
                                  ),
                                  content: Text(
                                    Strings.selectToSave,
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop(context);
                                      },
                                      child: const Text(Strings.ok),
                                    ),
                                  ],
                                ),
                              );
                              return;
                            }
                            if (_dropdownValue == _nullTag) {
                              bool? res = await showDialog(
                                  context: context,
                                  builder: (_) =>
                                      const NoDisciplineSelectedDialog());
                              if (res == null || !res) {
                                return;
                              }
                            }
                            List<QuestionItem> questionItems = [];
                            if (_dropdownValue == _nullTag) {
                              for (var q in _qWidgets!) {
                                final contained =
                                    await _storage.exists(q.question);
                                if (q.info.selected && !contained) {
                                  questionItems.add(q.question);
                                  q.info.unselect();
                                }
                              }
                            } else {
                              for (var q in _qWidgets!) {
                                final contained =
                                    await _storage.exists(q.question);
                                if (q.info.selected && !contained) {
                                  questionItems.add(q.question);
                                  questionItems.last.tag = _dropdownValue;
                                  q.info.unselect();
                                }
                              }
                            }

                            if (!_storage.isInitialized) {
                              await _storage.init();
                            }
                            await _storage.saveQuestions(questionItems);
                            ref.read(saveNotifierProvider).notify();
                            setState(() {});
                          },
                          child: const Text(
                            Strings.saveSelected,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: _qWidgets!,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
