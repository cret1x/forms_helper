import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forms_helper/common/strings.dart';
import 'package:forms_helper/entities/form.dart';
import 'package:forms_helper/entities/form_item.dart';
import 'package:forms_helper/global_providers.dart';
import 'package:forms_helper/google_api/auth.dart';
import 'package:forms_helper/google_api/forms.dart';
import 'package:forms_helper/screens/export/docx_export.dart';
import 'package:forms_helper/screens/export/pdf_export.dart';
import 'package:url_launcher/url_launcher.dart';

class ExportButton extends ConsumerStatefulWidget {
  final _authApi = GoogleAuthApi();
  final _formsApi = GoogleFormsApi();
  final void Function() action;
  final bool showImportForms;
  ExportButton({super.key, required this.showImportForms, required this.action});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExportButtonState();
}

class _ExportButtonState extends ConsumerState<ExportButton> {
  GForm? form;
  int startFrom = 0;


  void showResultDialog(BuildContext context, bool success) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actionsPadding: EdgeInsets.all(12),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        title: const Text(
          Strings.exportTitle,
          style: TextStyle(
            fontFamily: 'Verdana',
          ),
        ),
        content: Text(
          success ? Strings.exportSuccess : Strings.exportFailure,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(Strings.ok),
          ),
        ],
      ),
    );
  }

  void saveExportDialog(BuildContext parentContext) async {
    await showDialog(
      context: parentContext,
      builder: (context) => AlertDialog(
        actionsPadding: EdgeInsets.all(12),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        title: const Text(
          Strings.exportTitle,
          style: TextStyle(
            fontFamily: 'Verdana',
          ),
        ),
        content: Text(
          Strings.exportDescription,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        actions: [
          if (widget.showImportForms) TextButton(
            onPressed: () async {
              try {
                final token = await widget._authApi.getAccessToken();
                final formId = await widget._formsApi.create(form!, token, startFrom: startFrom);
                final url = 'https://docs.google.com/forms/d/$formId/edit';
                launchUrl(Uri.parse(url));
              } catch (e) {
                showResultDialog(context, false);
              }
            },
            child: const Text(Strings.exportToGoogle),
          ),
          TextButton(
            onPressed: () async {
              var res = await PDFExport.export(form!, startFrom: startFrom);
              showResultDialog(parentContext, res);
            },
            child: const Text(Strings.exportToPdf),
          ),
          TextButton(
            onPressed: () async {
              var res = await DocxExport.export(form!, startFrom: startFrom);
              showResultDialog(parentContext, res);
            },
            child: const Text(Strings.exportToDocx),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(Strings.cancel),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        widget.action();
        form = ref.read(formExportProvider);
        if (form == null) {
          return;
        }
        startFrom = ref.read(numerationProvider).numerate
            ? ref.read(numerationProvider).startsFrom
            : form?.items?.length ?? 0 + 1;
        saveExportDialog(context);
      },
      child: const Text(Strings.export),
    );
  }
}
