import 'package:flutter/material.dart';
import 'package:forms_helper/entities/choice_question.dart';

class QuestionWidgetInfo {
  late final bool _isContained = false;
  bool _isSelected = false;

  bool get selected {
    return _isSelected;
  }

  void _toggle() {
    _isSelected = !_isSelected;
  }

  void select() {
    _isSelected = true;
  }

  void unselect() {
    _isSelected = false;
  }
}

class QuestionWidget extends StatefulWidget {
  final ChoiceQuestion _question;
  final QuestionWidgetInfo info = QuestionWidgetInfo();

  QuestionWidget(this._question, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _QuestionWidgetState();
  }
}

class _QuestionWidgetState extends State<QuestionWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: ElevatedButton(
        onPressed: () {},
        style: ButtonStyle(
          fixedSize: const MaterialStatePropertyAll(Size.infinite),
          backgroundColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.background),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(6, 16, 0, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget._question.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: widget.info._isContained
                        ? const Icon(Icons.download_done)
                        : Checkbox(
                            value: widget.info.selected,
                            onChanged: (_) {
                              setState(() {
                                widget.info._toggle();
                              });
                            },
                          ),
                  )
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                widget._question.description,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Divider(),
              ),
              Column(
                children: widget._question.options
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: !widget._question.correctAnswers.contains(e)
                            ? Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 1, right: 13),
                                    child: Text(
                                      "-",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                  ),
                                  Text(
                                    e.value,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Text(
                                      "✓",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(color: Colors.green),
                                    ),
                                  ),
                                  Text(
                                    e.value,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ],
                              ),
                      ),
                    )
                    .toList(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
