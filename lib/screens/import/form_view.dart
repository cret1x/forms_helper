import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:forms_helper/entities/choice_question.dart';
import 'package:forms_helper/screens/import/question_widget.dart';
import 'package:forms_helper/screens/no_discipline_selected_dialog.dart';
import 'package:forms_helper/sqlite/local_storage.dart';

import '../../common/strings.dart';
import '../../entities/form.dart';
import '../../entities/question_item.dart';

class FormView extends StatefulWidget {
  final GForm form;
  final PageController pageController;
  final SideMenuController menuController;

  const FormView({required this.form,
                  required this.pageController,
                  required this.menuController,
                  super.key});

  @override
  State<StatefulWidget> createState() {
    return _FormViewState();
  }
}

class _FormViewState extends State<FormView> {
  bool _allSelected = false;
  List<QuestionWidget>? _qWidgets;
  final LocalStorage _storage = LocalStorage();

  final List<String> _disciplines = [
    Strings.notSelected,
    'Apple',
    'Orange',
    'Lemon'
  ];
  String _dropdownValue = Strings.notSelected;

  @override
  Widget build(BuildContext context) {
    _qWidgets ??= widget.form.items!
        .whereType<QuestionItem>()
        .map((e) => QuestionWidget(e))
        .toList();
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 500,
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
                      child: DropdownButtonFormField<String>(
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
                        borderRadius: BorderRadius.circular(15),
                        style: Theme.of(context).textTheme.titleMedium,
                        hint: Text(
                          Strings.discipline,
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .color!
                                        .withOpacity(0.4),
                                  ),
                        ),
                        value: _dropdownValue,
                        onChanged: (String? newValue) {
                          setState(() {
                            _dropdownValue = newValue!;
                          });
                        },
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: _disciplines
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
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
                        onPressed: () {
                          widget.pageController.jumpToPage(2);
                          widget.menuController.changePage(2);
                        },
                        child: const Text(Strings.edit),
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
                            _qWidgets?.forEach((w) {
                              if (_allSelected) {
                                w.info.unselect();
                              } else {
                                w.info.select();
                              }
                            });
                            setState(() {
                              _allSelected = !_allSelected;
                            });
                          },
                          child: Text(
                            _allSelected
                                ? Strings.unselectAll
                                : Strings.selectAll,
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (_dropdownValue == Strings.notSelected) {
                              bool? res = await showDialog(
                                  context: context,
                                  builder: (_) =>
                                      const NoDisciplineSelectedDialog());
                              if (res == null || !res) {
                                return;
                              }
                            }
                            List<QuestionItem> _questionItems = [];
                            if (_dropdownValue == Strings.noDisciplineSelected) {
                              for (var widget in _qWidgets!) {
                                if (widget.info.selected) {
                                  _questionItems.add(widget.question);
                                }
                              }
                            } else {
                              for (var widget in _qWidgets!) {
                                if (widget.info.selected) {
                                  _questionItems.add(widget.question);
                                  _questionItems.last.tag = _dropdownValue;
                                }
                              }
                            }

                            if (!_storage.isInitialized) {
                              await _storage.init();
                            }
                            _storage.saveQuestions(_questionItems);
                          },
                          child: const Text(
                            Strings.saveSelected,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    key: UniqueKey(),
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
