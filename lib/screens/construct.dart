import 'package:flutter/material.dart';
import 'package:forms_helper/common/strings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forms_helper/entities/question_item.dart';
import 'package:forms_helper/screens/import/question_item_widget.dart';
import '../common/themes.dart';
import '../entities/choice_question.dart';

final constructorProvider = StateNotifierProvider<
    ConstructorQuestionsStateNotifier,
    List<QuestionItem>>((ref) => ConstructorQuestionsStateNotifier());

class ConstructorQuestionsStateNotifier
    extends StateNotifier<List<QuestionItem>> {
  ConstructorQuestionsStateNotifier() : super([]);

  void addQuestion(QuestionItem questionItem) {
    if (!state.contains(questionItem)) {
      state = [...state, questionItem];
    }
  }

  void deleteQuestion(QuestionItem questionItem) {
    state = [
      for (final q in state)
        if (questionItem != q) q,
    ];
  }

  void moveQuestion(QuestionItem questionItem, int newIndex) {
    int index = 0;
    List<QuestionItem> newList = [];
    for (var q in state) {
      if (index == newIndex) {
        newList.add(questionItem);
        ++index;
      } else if (q != questionItem) {
        newList.add(q);
        ++index;
      }
    }
    state = newList;
  }
}

class FormConstructor extends ConsumerStatefulWidget {
  const FormConstructor({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _FormConstructorState();
  }
}

class _FormConstructorState extends ConsumerState<FormConstructor>
    with AutomaticKeepAliveClientMixin<FormConstructor> {
  final TextEditingController _filenameController = TextEditingController();
  final TextEditingController _headerController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  late List<QuestionItem> _questions;
  late List<QuestionItemWidget> _qWidgets;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _questions = ref.watch(constructorProvider);
    _qWidgets = _questions.map((e) => QuestionItemWidget(question: e)).toList();
    return MaterialApp(
      theme: Themes.darkBlue,
      home: Padding(
        padding: const EdgeInsets.symmetric(vertical: 26.0, horizontal: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Strings.construct,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(
              height: 24,
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      shrinkWrap: true,
                      children: [
                        TextField(
                          controller: _filenameController,
                          cursorColor: Theme.of(context).colorScheme.onPrimary,
                          decoration: InputDecoration(
                            hintText: Strings.name,
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
                        TextField(
                          controller: _headerController,
                          cursorColor: Theme.of(context).colorScheme.onPrimary,
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
                          cursorColor: Theme.of(context).colorScheme.onPrimary,
                          maxLines: 12,
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
                          height: 24,
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
                                        Strings.clearForm,
                                        style: TextStyle(
                                          fontFamily: 'Verdana',
                                        ),
                                      ),
                                      content: Text(
                                        Strings.clearConfirmation,
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
                                    setState(() {
                                      _headerController.text = "";
                                      _descriptionController.text = "";
                                      _questions.clear();
                                    });
                                  }
                                },
                                child: const Text(
                                  Strings.clear,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 24,
                            ),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {},
                                child: const Text(
                                  Strings.save,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: VerticalDivider(
                      thickness: 1,
                    ),
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
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              child: const Text(
                                Strings.add,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        _questions.isEmpty
                            ? Center(
                                child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 72),
                                child: Text(
                                  Strings.noQuestions,
                                  textAlign: TextAlign.center,
                                  style:
                                      Theme.of(context).textTheme.displaySmall,
                                ),
                              ))
                            : Expanded(
                                child: ListView(
                                  children: _qWidgets,
                                ),
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
    );
  }

  @override
  bool get wantKeepAlive => true;
}
