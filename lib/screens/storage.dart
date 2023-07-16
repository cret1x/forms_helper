import 'dart:math';

import 'package:flutter/material.dart';
import 'package:forms_helper/screens/import/question_item_widget.dart';

import '../common/strings.dart';
import '../common/themes.dart';
import '../entities/question_item.dart';
import '../sqlite/local_storage.dart';

class StorageWidget extends StatefulWidget {
  const StorageWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return _StorageWidgetState();
  }
}

class _StorageWidgetState extends State<StorageWidget>
    with
        AutomaticKeepAliveClientMixin<StorageWidget>,
        SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final LocalStorage _storage = LocalStorage();
  String? _dropdownValue;
  int page = 0;
  late Animation<double> _animation;
  late AnimationController _animationController;

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
        searchText: _controller.text, page: page, tag: _dropdownValue);
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
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    cursorColor: Theme.of(context).colorScheme.onPrimary,
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
                  width: 14,
                ),
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
                  width: 14,
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text(
                    Strings.add,
                  ),
                ),
                const SizedBox(
                  width: 14,
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
            FutureBuilder(
              future: _questions,
              builder: (context, snapshot) {
                return snapshot.hasData
                    ? Expanded(
                      child: ListView(
                          shrinkWrap: true,
                          children: snapshot.data!
                              .map((e) => QuestionItemWidget(e))
                              .toList(),
                        ),
                    )
                    : CircularProgressIndicator(
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
