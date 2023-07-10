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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Strings.name,
                      style: Theme.of(context).textTheme.titleMedium,
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Strings.header,
                      style: Theme.of(context).textTheme.titleMedium,
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Strings.description,
                      style: Theme.of(context).textTheme.titleMedium,
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
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: widget._form.questions?.map((e) => Column(children: [Text(e.title), Text(e.description)],)).toList() ?? [],
            ),
          ),
        ],
      ),
    );
  }
}
