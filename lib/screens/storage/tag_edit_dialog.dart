import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forms_helper/global_providers.dart';
import 'package:forms_helper/sqlite/local_storage.dart';

import '../../common/strings.dart';
import '../../entities/question_tag.dart';

class TagEditDialog extends ConsumerStatefulWidget {
  final Tag? tag;

  const TagEditDialog({this.tag, super.key});

  @override
  ConsumerState< ConsumerStatefulWidget> createState() {
    return _TagEditDialogState();
  }
}

class _TagEditDialogState extends  ConsumerState<TagEditDialog> {
  late final TextEditingController _controller;
  final LocalStorage _storage = LocalStorage();

  @override
  void initState() {
    _controller = widget.tag == null
        ? TextEditingController()
        : TextEditingController(text: widget.tag!.value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.tag == null ? Strings.addTag : Strings.editTag,
        style: const TextStyle(
          fontFamily: 'Verdana',
        ),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      content: TextField(
        controller: _controller,
        cursorColor: Theme.of(context).colorScheme.onPrimary,
        decoration: InputDecoration(
          hintText: Strings.name,
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
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(Strings.cancel),
        ),
        TextButton(
          onPressed: () async {
            if (widget.tag == null) {
              final tag = Tag(value: _controller.text);
              ref.read(disciplinesProvider.notifier).addDiscipline(tag);
            } else {
              widget.tag!.value = _controller.text;
              await _storage.updateTag(widget.tag!);
            }
            Navigator.pop(context, true);
          },
          child: const Text(Strings.save),
        ),
      ],
      actionsPadding: const EdgeInsets.only(right: 18, bottom: 16),
    );
  }
}
