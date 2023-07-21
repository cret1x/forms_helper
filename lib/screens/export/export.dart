import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:forms_helper/entities/answer.dart';
import 'package:forms_helper/entities/choice_question.dart';
import 'package:forms_helper/entities/form.dart';
import 'package:forms_helper/entities/form_item.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path/path.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:printing/printing.dart';

class PDFExport {
  static pw.Widget q2w(FormItem item) {
    late List<Answer> options;
    if (item is ChoiceQuestion) {
      options = item.options;
    } else {
      options = [];
    }
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Header(level: 3, text: item.title),
        pw.Text(item.description),
        pw.Padding(
          padding: const pw.EdgeInsets.all(16),
          child: options.isNotEmpty
              ? pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: options.map((e) => pw.Text(e.value)).toList(),
                )
              : pw.Divider(),
        ),
      ],
    );
  }

  static void export(GForm form) async {
    final dir = await getApplicationDocumentsDirectory();
    final font = await PdfGoogleFonts.robotoMedium();
    final pdf = pw.Document(
      theme: pw.ThemeData(
        defaultTextStyle: pw.TextStyle(font: font),
        header0: pw.TextStyle(font: font),
        header1: pw.TextStyle(font: font),
        header2: pw.TextStyle(font: font),
        header3: pw.TextStyle(font: font),
      ),
    );
    final q = form.items?.map(q2w).toList() ?? [];
    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(level: 3, text: form.title),
              pw.Text(form.description),
              pw.Padding(
                padding: const pw.EdgeInsets.only(top: 32),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: q,
                ),
              ),
            ],
          );
        })); // Page
    final file = File(join(dir.path, "example.pdf"));
    await file.writeAsBytes(await pdf.save());
  }
}
