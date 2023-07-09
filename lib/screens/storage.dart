import 'package:flutter/material.dart';

import '../common/strings.dart';
import '../common/themes.dart';

class StorageWidget extends StatefulWidget {
  const StorageWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return _StorageWidgetState();
  }
}

class _StorageWidgetState extends State<StorageWidget>
    with AutomaticKeepAliveClientMixin<StorageWidget> {
  final TextEditingController _controller = TextEditingController();
  String? _dropdownValue;

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
                  width: 28,
                ),
                Flexible(
                  child: DropdownButtonFormField(
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(17),
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
                  width: 28,
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text(
                    Strings.add,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
