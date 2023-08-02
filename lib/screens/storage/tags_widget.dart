import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forms_helper/global_providers.dart';
import 'package:forms_helper/screens/storage/tag_edit_dialog.dart';

import '../../common/strings.dart';
import '../../entities/question_tag.dart';
import '../../sqlite/local_storage.dart';

class TagsListWidget extends ConsumerStatefulWidget {
  const TagsListWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _TagsListWidgetState();
  }
}

class _TagsListWidgetState extends ConsumerState<TagsListWidget> {
  final LocalStorage _storage = LocalStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(vertical: 26.0, horizontal: 28),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Strings.disciplinesList,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      bool? res = await showDialog(
                        context: context,
                        builder: (context) => const TagEditDialog(),
                      );
                      if (res != null) {
                        setState(() {});
                      }
                    },
                    child: const Icon(Icons.add),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(Strings.back),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 24,
          ),
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              key: UniqueKey(),
              itemBuilder: (BuildContext context, int index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      ref.read(disciplinesProvider)[index].value,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () async {
                            bool? res = await showDialog(
                              context: context,
                              builder: (context) => TagEditDialog(
                                tag: ref.read(disciplinesProvider)[index],
                              ),
                            );
                            if (res != null) {
                              setState(() {});
                            }
                          },
                          icon: const Icon(Icons.edit_outlined),
                        ),
                        IconButton(
                          onPressed: () async {
                            bool? res = await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  actionsPadding: const EdgeInsets.all(12),
                                  title: const Text(
                                    Strings.deleteQuestions,
                                  ),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15),
                                    ),
                                  ),
                                  content: Text(
                                    Strings.cantRedo,
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
                                        Navigator.pop(context);
                                      },
                                      child: const Text(Strings.no),
                                    ),
                                  ],
                                );
                              },
                            );
                            if (res == null) {
                              return;
                            }
                            ref
                                .read(disciplinesProvider.notifier)
                                .deleteDiscipline(
                                    ref.read(disciplinesProvider)[index]);
                            setState(() {});
                          },
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider();
              },
              itemCount: ref.read(disciplinesProvider).length,
            ),
          ),
        ],
      ),
    ));
  }
}
