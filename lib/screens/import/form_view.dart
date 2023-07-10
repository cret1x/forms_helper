import 'package:flutter/material.dart';

import '../../common/strings.dart';
import '../../entities/form.dart';

class FormView extends StatefulWidget {
  final GForm _form;

  const FormView(this._form, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _FormViewState();
  }
}

class _FormViewState extends State<FormView> {
  bool _allSelected = false;

  @override
  Widget build(BuildContext context) {
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
                        widget._form.documentTitle,
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
                        widget._form.title,
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
                        widget._form.description,
                        style: Theme.of(context).textTheme.displaySmall,
                        minLines: 1,
                        maxLines: 18,
                        textAlign: TextAlign.end,
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
                          onPressed: () {
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
                  child:
                      ListView(
                        shrinkWrap: true,
                        children: widget._form.questions?.map((e) => Column(children: [Text(e.title), Text(e.description)],)).toList() ?? [],
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
