// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:forms_helper/entities/form.dart';
import 'package:forms_helper/google_api/auth.dart';
import 'package:forms_helper/google_api/forms.dart';
import 'package:forms_helper/screens/import/form_view.dart';
import '../../common/strings.dart';
import '../../common/themes.dart';

class ImportWidget extends StatefulWidget {
  const ImportWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ImportWidgetState();
  }
}

class _ImportWidgetState extends State<ImportWidget>
    with AutomaticKeepAliveClientMixin<ImportWidget> {
  final TextEditingController _linkController = TextEditingController();
  final _formsApi =
      GoogleFormsApi(url: "https://forms.googleapis.com/v1/forms");
  final _authApi = GoogleAuthApi();
  GForm? _content;
  bool _importButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Themes.darkBlue,
      home: Padding(
        padding: const EdgeInsets.symmetric(vertical: 26.0, horizontal: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Strings.import,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(
              height: 24,
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _linkController,
                    cursorColor: Theme.of(context).colorScheme.onPrimary,
                    decoration: InputDecoration(
                      hintText: Strings.insertLink,
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
                ),
                const SizedBox(
                  width: 24,
                ),
                _importButtonPressed
                    ? CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.onPrimary,
                      )
                    : ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            _importButtonPressed = true;
                          });
                          final token = await _authApi.getAccessToken();
                          final result =
                              await _formsApi.get(_linkController.text, token);
                          setState(() {
                            _importButtonPressed = false;
                          });
                          switch (result.error) {
                            case FormsError.OK:
                              setState(() {
                                _content = result.form;
                              });
                              break;
                            case FormsError.AUTH_REQUIRED:
                              await showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    actionsPadding: const EdgeInsets.all(12),
                                    title: const Text(
                                      Strings.accessError,
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
                                      Strings.reauth,
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text(Strings.ok),
                                      ),
                                    ],
                                  );
                                },
                              );
                              break;
                            case FormsError.INVALID_URL:
                              await showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    actionsPadding: const EdgeInsets.all(12),
                                    title: const Text(
                                      Strings.wrongLink,
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
                                      Strings.checkLink,
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text(Strings.ok),
                                      ),
                                    ],
                                  );
                                },
                              );
                          }
                        },
                        child: const Text(
                          Strings.download,
                        ),
                      ),
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            _content != null
                ? FormView(_content!)
                : Padding(
                    padding: const EdgeInsets.only(top: 82),
                    child: Center(
                      child: Text(
                        Strings.importCommon,
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
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
