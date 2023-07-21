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
  static pw.Widget q2w(FormItem item, int index, int startFrom) {
    late List<Answer> options;
    if (item is ChoiceQuestion) {
      options = item.options;
    } else {
      options = [];
    }
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Header(level: 3, text: '${index <= startFrom ? "" : "${index - startFrom}. "}${item.title}'),
        pw.Text(item.description),
        pw.Padding(
          padding: const pw.EdgeInsets.all(16),
          child: options.isNotEmpty
              ? pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: options.map((e) => pw.Text(e.value)).toList(),
                )
              : pw.DecoratedBox(
                  decoration: const pw.BoxDecoration(
                    color: PdfColors.black,
                    border: pw.Border(
                      bottom: pw.BorderSide(),
                    ),
                  ),
                  child: pw.Expanded(
                    child: pw.SizedBox(height: 1, width: double.infinity,),
                  ),
                ),
        ),
      ],
    );
  }

  static void export(GForm form, {int startFrom = 0}) async {
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
                child: pw.ListView.builder(
                    itemCount: form.items?.length ?? 0,
                    itemBuilder: (context, index) {
                      return q2w(form.items![index], index + 1, startFrom);
                    }),
              ),
            ],
          );
        })); // Page
    final file = File(join(dir.path, "example.pdf"));
    await file.writeAsBytes(await pdf.save());
  }
}
