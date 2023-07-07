import 'package:flutter/material.dart';
import 'package:forms_helper/common/strings.dart';

import '../common/themes.dart';

class FormConstructor extends StatefulWidget {
  const FormConstructor({super.key});

  @override
  State<StatefulWidget> createState() {
    return _FormConstructorState();
  }
}

class _FormConstructorState extends State<FormConstructor> with AutomaticKeepAliveClientMixin<FormConstructor> {
  final TextEditingController _editingController = TextEditingController();

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
              Strings.construct,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            SizedBox(
              height: 24,
            ),
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        TextField(
                          controller: _editingController,
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
                              child: Text(
                                Strings.add,
                              ),
                            )
                          ],
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
