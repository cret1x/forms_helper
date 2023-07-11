import 'package:flutter/material.dart';
import 'package:forms_helper/entities/question.dart';

class QuestionWidget extends StatefulWidget {
  final Question _question;
  final bool _isContained = false;

  const QuestionWidget(this._question, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _QuestionWidgetState();
  }
}

class _QuestionWidgetState extends State<QuestionWidget> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget._isContained
            ? const Icon(Icons.download_done)
            : Checkbox(
                value: _isSelected,
                onChanged: (_) {
                  setState(() {
                    _isSelected = !_isSelected;
                  });
                },
              ),
        Padding(
          padding: const EdgeInsets.only(top: 1, left: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget._question.title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                widget._question.description,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(
                height: 8,
              ),
              Column(
                children: widget._question.answers
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: widget._question.correctAnswers.contains(e)
                            ? Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 1, right: 13),
                                    child: Text(
                                      "-",
                                      style:
                                          Theme.of(context).textTheme.titleMedium,
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
      ],
    );
  }
}
