import 'package:flutter/material.dart';

import '../common/strings.dart';

class NoDisciplineSelectedDialog extends StatelessWidget {
  const NoDisciplineSelectedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsPadding: const EdgeInsets.all(12),
      title: const Text(
        Strings.sure,
        style: TextStyle(
          fontFamily: 'Verdana',
        ),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      content: Text(
        Strings.noDisciplineSelected,
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
            Navigator.pop(context, false);
          },
          child: const Text(Strings.no),
        ),
      ],
    );
  }
}