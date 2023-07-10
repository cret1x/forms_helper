import 'package:flutter/material.dart';
import 'package:forms_helper/entities/form.dart';
import 'package:forms_helper/google_api/auth.dart';
import 'package:forms_helper/google_api/forms.dart';
import 'package:forms_helper/screens/form_view.dart';
import '../common/strings.dart';
import '../common/themes.dart';

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
  final api = GoogleFormsApi(url: "https://forms.googleapis.com/v1/forms");
  Future<GForm?>? _content;

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
                ElevatedButton(
                  onPressed: () async {
                    _content = api.get(_linkController.text,
                        await GoogleAuthApi().getAccessToken());
                    setState(() {});
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
            FutureBuilder(
              future: _content,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                return snapshot.hasData
                    ? FormView(snapshot.data)
                    : Padding(
                        padding: const EdgeInsets.only(top: 82),
                        child: Center(
                          child: Text(
                            Strings.importCommon,
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                        ),
                      );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
