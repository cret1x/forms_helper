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

class ExportButton extends ConsumerStatefulWidget {
  final List<FormItem> items;
  final _authApi = GoogleAuthApi();
  final _formsApi = GoogleFormsApi();

  ExportButton({super.key, required this.items});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExportButtonState();
}

class _ExportButtonState extends ConsumerState<ExportButton> {
  GForm? form;
  int startFrom = 0;
  String _exportGoogleText = Strings.exportToGoogle;
  String _exportPdfText = Strings.exportToPdf;
  String _exportDocxText = Strings.exportToDocx;

  bool _googlePending = false;
  bool _pdfPending = false;
  bool _docxPending = false;

  void saveExportDialog(BuildContext context) async {
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
          "SAVE OR EXPORT",
          style: TextStyle(
            fontFamily: 'Verdana',
          ),
        ),
        content: Text(
          "SAVE OR EXPORT !",
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              setState(() {
                _googlePending = true;
              });
              final token = await widget._authApi.getAccessToken();
              await widget._formsApi.create(form!, token, startFrom: startFrom);
              setState(() {
                _googlePending = false;
              });
            },
            child: _googlePending
                ? const CircularProgressIndicator()
                : Text(_exportGoogleText),
          ),
          TextButton(
            onPressed: () async {
              setState(() {
                _pdfPending = true;
              });
              await PDFExport.export(form!, startFrom: startFrom);
              setState(() {
                _pdfPending = false;
              });
            },
            child: _pdfPending
                ? const CircularProgressIndicator()
                : Text(_exportPdfText),
          ),
          TextButton(
            onPressed: () async {
              await DocxExport.export(form!, startFrom: startFrom);
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
        form = GForm(
            title: ref.read(formInfoProvider).titleController.text,
            description: ref.read(formInfoProvider).descriptionController.text,
            documentTitle: ref.read(formInfoProvider).filenameController.text,
            items: widget.items);
        saveExportDialog(context);
      },
      child: const Text("EXPORT"),
    );
  }
}
