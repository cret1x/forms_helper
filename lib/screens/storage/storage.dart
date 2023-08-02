import 'dart:math';

import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forms_helper/screens/common_widgets/question_edit_widget.dart';
import 'package:forms_helper/screens/common_widgets/question_item_widget.dart';
import 'package:forms_helper/screens/storage/tags_widget.dart';

import '../../common/strings.dart';
import '../../common/themes.dart';
import '../../entities/question_item.dart';
import '../../entities/question_tag.dart';
import '../../global_providers.dart';
import '../../sqlite/local_storage.dart';

class StorageWidget extends ConsumerStatefulWidget {
  final PageController pageController;
  final SideMenuController menuController;

  const StorageWidget({
    required this.pageController,
    required this.menuController,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _StorageWidgetState();
  }
}

class _StorageWidgetState extends ConsumerState<StorageWidget>
    with
        AutomaticKeepAliveClientMixin<StorageWidget>,
        SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final LocalStorage _storage = LocalStorage();
  Tag? _dropdownValue;
  late Animation<double> _animation;
  late AnimationController _animationController;
  List<QuestionItemWidget>? _qWidgets;
  late List<QuestionItem> _constructQuestions;
  int _page = 1;
  final Tag _nullTag = Tag(id: "", value: Strings.notSelected);
  List<Tag>? _disciplines;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    setRotation(360);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void setRotation(int degrees) {
    final angle = degrees * pi / 180;

    _animation =
        Tween<double>(begin: 0, end: angle).animate(_animationController);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _disciplines = ref.watch(disciplinesProvider);
    _dropdownValue ??= _nullTag;
    Future<List<QuestionItem>> questions = _storage.getQuestions(
        searchText: _controller.text,
        page: _page - 1,
        tag: _dropdownValue == _nullTag ? null : _dropdownValue);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 26.0, horizontal: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Strings.storage,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(
            height: 24,
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  cursorColor: Theme.of(context).colorScheme.onPrimary,
                  onChanged: (_) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    hintText: Strings.findQuestion,
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
                    prefixIconConstraints: const BoxConstraints(
                      minWidth: 50,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              ElevatedButton(
                onPressed: _page == 1
                    ? null
                    : () {
                        setState(() {
                          _page = 1;
                        });
                      },
                child: const Icon(Icons.keyboard_double_arrow_left_rounded),
              ),
              const SizedBox(
                width: 12,
              ),
              ElevatedButton(
                onPressed: _page == 1
                    ? null
                    : () {
                        setState(() {
                          --_page;
                        });
                      },
                child: const Icon(Icons.arrow_back_rounded),
              ),
              const SizedBox(
                width: 12,
              ),
              ElevatedButton(
                onPressed: null,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    _page.toString(),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              ElevatedButton(
                onPressed: _page == _storage.pages || _storage.pages == 0
                    ? null
                    : () {
                        setState(() {
                          ++_page;
                        });
                      },
                child: const Icon(Icons.arrow_forward_rounded),
              ),
              const SizedBox(
                width: 12,
              ),
              ElevatedButton(
                onPressed: _page == _storage.pages || _storage.pages == 0
                    ? null
                    : () {
                        setState(() {
                          _page = _storage.pages;
                        });
                      },
                child: const Icon(Icons.keyboard_double_arrow_right_rounded),
              ),
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            children: [
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
              const SizedBox(
                width: 12,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const TagsListWidget(),
                      ));
                },
                child: const Icon(
                  Icons.tag,
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              ElevatedButton(
                onPressed: () {
                  _constructQuestions = ref.read(constructorQuestionsProvider);
                  final selectedQuestions = ref.read(storageProvider);

                  for (var q in selectedQuestions) {
                    if (!_constructQuestions.contains(q)) {
                      ref
                          .read(constructorQuestionsProvider.notifier)
                          .addQuestion(q);
                    }
                  }

                  widget.pageController.jumpToPage(2);
                  widget.menuController.changePage(2);
                },
                child: const Icon(
                  Icons.construction,
                ),
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
                        actionsPadding: const EdgeInsets.all(12),
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
                  if (res != null) {
                    for (var q in ref.read(storageProvider)) {
                      if (!ref.read(constructorQuestionsProvider).contains(q)) {
                        await _storage.deleteQuestion(q);
                      }
                    }
                    setState(() {});
                  }
                },
                child: const Icon(
                  Icons.delete_outline,
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              ElevatedButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => QuestionEditWidget(),
                    ),
                  );
                  setState(() {});
                },
                child: const Icon(
                  Icons.add,
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              ElevatedButton(
                onPressed: () async {
                  _animationController.forward(from: 0);
                  await _storage.update();
                  setState(() {});
                },
                child: AnimatedBuilder(
                  animation: _animation,
                  child: const Icon(Icons.refresh),
                  builder: (context, child) => Transform.rotate(
                    angle: _animation.value,
                    child: child,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 24,
          ),
          FutureBuilder(
            future: questions,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                _qWidgets = snapshot.data!
                    .map((e) => QuestionItemWidget(
                          question: e,
                          fromStorageScreen: true,
                        ))
                    .toList();
                if (_qWidgets!.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 48),
                    child: Center(
                      child: Text(
                        Strings.noQuestionsYet,
                        style: Theme.of(context).textTheme.displaySmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                return Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    key: UniqueKey(),
                    children: _qWidgets!,
                  ),
                );
              }
              return CircularProgressIndicator(
                color: Theme.of(context).colorScheme.onPrimary,
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
