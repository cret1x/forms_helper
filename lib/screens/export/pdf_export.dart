import 'dart:io';

import 'package:forms_helper/entities/answer.dart';
import 'package:forms_helper/entities/choice_question.dart';
import 'package:forms_helper/entities/form.dart';
import 'package:forms_helper/entities/form_item.dart';
import 'package:forms_helper/entities/question_item.dart';
import 'package:forms_helper/entities/text_question.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path/path.dart';
import 'package:printing/printing.dart';
import 'package:file_picker/file_picker.dart';

class PDFExport {
  static pw.Widget q2w(FormItem item, int index, int startFrom) {
    late List<Answer> options;
    if (item is ChoiceQuestion) {
      options = item.options;
    } else {
      options = [];
    }
    return pw.Padding(
        padding: const pw.EdgeInsets.only(top: 16),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Flexible(
                  child: pw.Header(
                      level: 3,
                      text:
                          '${index <= startFrom ? "" : "${index - startFrom}. "}${item.title}'),
                ),
                (item is QuestionItem && item.required && item.pointValue > 0)
                    ? pw.Text('(${item.pointValue} балл)')
                    : pw.Spacer(),
              ],
            ),
            if (item.description.isNotEmpty) pw.Text(item.description),
            pw.Padding(
              padding: pw.EdgeInsets.all((index <= startFrom) ? 0 : 8),
              child: options.isNotEmpty
                  ? pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: options
                          .map((e) => pw.Padding(
                              padding:
                                  const pw.EdgeInsets.symmetric(vertical: 4),
                              child: pw.Text('- ${e.value}')))
                          .toList(),
                    )
                  : pw.Expanded(
                      child: pw.Column(
                          children: (item is TextQuestion && item.paragraph)
                              ? [
                                  pw.Header(level: 1, text: ''),
                                  pw.Header(level: 1, text: ''),
                                  pw.Header(level: 1, text: ''),
                                ]
                              : [
                                  pw.Header(level: 1, text: ''),
                                ])),
            ),
          ],
        ));
  }

  static Future<pw.Document> buildPDF(GForm form, {int startFrom = 0}) async {
    final headerFont = await PdfGoogleFonts.robotoMedium();
    final font = await PdfGoogleFonts.robotoLight();
    final fallbackFont = await PdfGoogleFonts.openSansRegular();
    final pdf = pw.Document(
      theme: pw.ThemeData(
        defaultTextStyle: pw.TextStyle(font: font, fontSize: 10, fontFallback: [fallbackFont]),
        header0: pw.TextStyle(font: headerFont, fontFallback: [fallbackFont]),
        header1: pw.TextStyle(font: headerFont, fontSize: 10, fontFallback: [fallbackFont]),
        header2: pw.TextStyle(font: headerFont, fontSize: 18, fontFallback: [fallbackFont]),
        header3: pw.TextStyle(font: headerFont, fontSize: 10, fontFallback: [fallbackFont]),
      ),
    );
    pdf.addPage(pw.MultiPage(build: (context) {
      return [
        pw.Header(level: 2, text: form.title),
        pw.Text(form.description),
        pw.Padding(
          padding: const pw.EdgeInsets.only(top: 0),
          child: pw.ListView.builder(
              itemCount: form.items?.length ?? 0,
              itemBuilder: (context, index) {
                return q2w(form.items![index], index + 1, startFrom);
              }),
        ),
      ];
    }));

    return pdf;
  }

  static Future<bool> export(GForm form, {int startFrom = 0}) async {
    String? dir = await FilePicker.platform.saveFile(allowedExtensions: ['pdf'], type: FileType.custom, fileName: form.documentTitle);
    if (dir != null) {
      try {
        print(dir);
        final pdf = await buildPDF(form, startFrom: startFrom);
        final file = File(dir);
        final res = await file.writeAsBytes(await pdf.save());
        return res.existsSync();
      } catch (e) {
        print(e);
        return false;
      }
    }
    return false;
  }
}
