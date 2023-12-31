import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:forms_helper/common/strings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forms_helper/entities/question_item.dart';
import 'package:forms_helper/google_api/auth.dart';
import 'package:forms_helper/google_api/forms.dart';
import 'package:forms_helper/screens/common_widgets/question_item_widget.dart';
import 'package:forms_helper/screens/export/export_button.dart';
import '../common/themes.dart';
import '../entities/form.dart';
import '../global_providers.dart';
import 'package:reorderables/reorderables.dart';

class FormConstructor extends ConsumerStatefulWidget {
  final PageController pageController;
  final SideMenuController menuController;

  const FormConstructor({
    required this.pageController,
    required this.menuController,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _FormConstructorState();
  }
}

class _FormConstructorState extends ConsumerState<FormConstructor>
    with AutomaticKeepAliveClientMixin<FormConstructor> {
  late List<QuestionItem> _questions;
  List<QuestionItemWidget>? _qWidgets;
  final GoogleFormsApi _formsApi =
      GoogleFormsApi(url: "https://forms.googleapis.com/v1/forms");
  final GoogleAuthApi _authApi = GoogleAuthApi();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _questions = ref.read(constructorQuestionsProvider);
    _qWidgets ??= _questions
        .map((e) => QuestionItemWidget(
              question: e,
              key: UniqueKey(),
            ))
        .toList();
    ref.listen(constructorQuestionsProvider, (previous, next) {
      _qWidgets = [];
      for (var q in next) {
        _qWidgets!.add(QuestionItemWidget(
          question: q,
          key: UniqueKey(),
        ));
        if (ref.read(constructorSelectedProvider).contains(q)) {
          _qWidgets!.last.info.select();
        }
      }
      setState(() {});
    });
    return Padding(
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
                  flex: 45,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(0, 4, 24, 4),
                    shrinkWrap: true,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 6, bottom: 40),
                        child: Text(
                          Strings.properties,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      TextField(
                        controller:
                            ref.read(formInfoProvider).filenameController,
                        cursorColor: Theme.of(context).colorScheme.onPrimary,
                        decoration: InputDecoration(
                          hintText: Strings.name,
                          hintStyle:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
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
                        height: 12,
                      ),
                      TextField(
                        controller: ref.read(formInfoProvider).titleController,
                        cursorColor: Theme.of(context).colorScheme.onPrimary,
                        decoration: InputDecoration(
                          hintText: Strings.header,
                          hintStyle:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
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
                        height: 12,
                      ),
                      TextFormField(
                        controller:
                            ref.read(formInfoProvider).descriptionController,
                        cursorColor: Theme.of(context).colorScheme.onPrimary,
                        maxLines: 12,
                        decoration: InputDecoration(
                          hintText: Strings.description,
                          hintStyle:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
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
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            Strings.autonumerate,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Checkbox(
                              value: ref.read(numerationProvider).numerate,
                              onChanged: (value) {
                                setState(() {
                                  ref.read(numerationProvider).numerate =
                                      value!;
                                });
                              })
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            Strings.startingFrom,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: ref
                                                .read(numerationProvider)
                                                .startsFrom ==
                                            0 ||
                                        !ref.read(numerationProvider).numerate
                                    ? null
                                    : () {
                                        setState(() {
                                          --ref
                                              .read(numerationProvider)
                                              .startsFrom;
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
                                  (ref.read(numerationProvider).startsFrom + 1)
                                      .toString(),
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              ElevatedButton(
                                onPressed: ref
                                                .read(numerationProvider)
                                                .startsFrom >=
                                            ref
                                                    .read(
                                                        constructorQuestionsProvider)
                                                    .length -
                                                1 ||
                                        !ref.read(numerationProvider).numerate
                                    ? null
                                    : () {
                                        setState(() {
                                          ++ref
                                              .read(numerationProvider)
                                              .startsFrom;
                                        });
                                      },
                                child: const Icon(Icons.add),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: const ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.redAccent),
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
                                      Strings.cantBackup,
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
                                    ref.read(formInfoProvider).clear();
                                    ref
                                        .read(constructorQuestionsProvider
                                            .notifier)
                                        .clear();
                                    ref
                                        .read(constructorSelectedProvider
                                            .notifier)
                                        .clear();
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
                            child: ExportButton(showImportForms: true, action: () {
                              var form = GForm(
                                  title: ref.read(formInfoProvider).titleController.text,
                                  description: ref.read(formInfoProvider).descriptionController.text,
                                  documentTitle: ref.read(formInfoProvider).filenameController.text,
                                  items: _questions);
                              ref.read(formExportProvider.notifier).setForm(form);
                            },),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 8, 24, 8),
                  child: VerticalDivider(
                    thickness: 1,
                  ),
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
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  ref
                                      .read(
                                          constructorSelectionProvider.notifier)
                                      .toggle();
                                  setState(() {});
                                },
                                child: Text(
                                    ref.read(constructorSelectionProvider)
                                        ? Strings.unselectAll
                                        : Strings.selectAll),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  bool? res = await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        actionsPadding:
                                            const EdgeInsets.all(12),
                                        title: const Text(
                                          Strings.deleteQuestions,
                                        ),
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(15),
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
                                              Navigator.pop(context);
                                            },
                                            child: const Text(Strings.no),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  if (res == null) {
                                    return;
                                  }
                                  for (var q in ref
                                      .read(constructorSelectedProvider)) {
                                    ref
                                        .read(constructorQuestionsProvider
                                            .notifier)
                                        .deleteQuestion(q);
                                    ref
                                        .read(constructorSelectedProvider
                                            .notifier)
                                        .deleteQuestion(q);
                                  }
                                },
                                child: const Text(
                                  Strings.deleteSelected,
                                ),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  widget.pageController.jumpToPage(1);
                                  widget.menuController.changePage(1);
                                },
                                child: const Icon(
                                  Icons.add,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      _questions.isEmpty
                          ? Center(
                              child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 72),
                              child: Text(
                                Strings.noQuestions,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.displaySmall,
                              ),
                            ))
                          : Expanded(
                              child: ReorderableColumn(
                                draggedItemBuilder: (context, index) {
                                  var w = QuestionItemWidget(
                                    question: _qWidgets![index].question,
                                    noPadding: true,
                                  );
                                  if (_qWidgets![index].info.selected) {
                                    w.info.select();
                                  }
                                  return w;
                                },
                                onReorder: (int oldIndex, int newIndex) {
                                  ref
                                      .read(
                                          constructorQuestionsProvider.notifier)
                                      .moveQuestion(oldIndex, newIndex);
                                },
                                children: _qWidgets!,
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
    );
  }

  @override
  bool get wantKeepAlive => true;
}
