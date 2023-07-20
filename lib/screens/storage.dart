import 'dart:math';

import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forms_helper/screens/construct.dart';
import 'package:forms_helper/screens/common_widgets/question_item_widget.dart';

import '../common/strings.dart';
import '../common/themes.dart';
import '../entities/question_item.dart';
import '../global_providers.dart';
import '../sqlite/local_storage.dart';

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
  String? _dropdownValue;
  late Animation<double> _animation;
  late AnimationController _animationController;
  List<QuestionItemWidget>? _qWidgets;
  late List<QuestionItem> _constructQuestions;
  int _page = 1;

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
    Future<List<QuestionItem>> _questions = _storage.getQuestions(
        searchText: _controller.text, page: _page - 1, tag: _dropdownValue);
    return MaterialApp(
      theme: Themes.darkBlue,
      home: Padding(
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
            TextField(
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
                hintStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
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
            const SizedBox(
              height: 12,
            ),
            Row(
              children: [
                Flexible(
                  child: DropdownButtonFormField(
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
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
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
                    items: <String>['Apple', 'Mango', 'Banana', 'Peach']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
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
                  child: Text(
                    _page.toString(),
                    style: Theme.of(context).textTheme.titleLarge,
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
                const SizedBox(
                  width: 12,
                ),
                ElevatedButton(
                  onPressed: () {
                    _constructQuestions = ref.read(constructorProvider);
                    final selectedQuestions = ref.read(storageProvider);

                    for (var q in selectedQuestions) {
                      if (!_constructQuestions.contains(q)) {
                        ref.read(constructorProvider.notifier).addQuestion(q);
                      }
                    }

                    widget.pageController.jumpToPage(2);
                    widget.menuController.changePage(2);
                  },
                  child: const Text(
                    Strings.toConstructor,
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Icon(
                    Icons.add,
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                ElevatedButton(
                  onPressed: () {
                    _animationController.forward(from: 0);
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
              future: _questions,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  _qWidgets = snapshot.data!
                      .map((e) => QuestionItemWidget(
                            question: e,
                            fromStorageScreen: true,
                          ))
                      .toList();
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
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
