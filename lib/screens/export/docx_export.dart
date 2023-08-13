import 'dart:io';

import 'package:flutter/services.dart';
import 'package:forms_helper/entities/answer.dart';
import 'package:forms_helper/entities/choice_question.dart';
import 'package:forms_helper/entities/form.dart';
import 'package:forms_helper/entities/form_item.dart';
import 'package:forms_helper/entities/question_item.dart';
import 'package:forms_helper/entities/text_question.dart';
import 'package:docx_template/docx_template.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';

class DocxExport {

  static String getPluralForm(int n) {
    if (n == 1) {
      return 'балл';
    } else if (n < 5) {
      return 'балла';
    } else {
      return 'баллов';
    }
  }

  static Content buildDocx(GForm form, {int startFrom = 0}) {
    Content c = Content();
    c..add(TextContent("title", form.title))..add(
        TextContent("description", form.description))..add(ListContent(
        "questions",
        form.items
            ?.asMap()
            .entries
            .map((e) {
          int idx = e.key + 1;
          FormItem val = e.value;
          return PlainContent('question')
            ..add(TextContent('qtitle',
                '${idx <= startFrom ? "" : "${idx - startFrom}. "}${val
                    .title}'))..add(TextContent(
                'pointValue',
                (val is QuestionItem &&
                    val.required &&
                    val.pointValue > 0)
                    ? '  (${val.pointValue} ${getPluralForm(val.pointValue)})'
                    : ''))..add(
                TextContent('qdescription', val.description))..add(ListContent(
                'qOptions',
                (val is ChoiceQuestion)
                    ? val.options
                    .map(
                        (op) => TextContent('qOption', '⬜ ${op.value}'))
                    .toList()
                    : (val is TextQuestion)
                    ? (val.paragraph)
                    ? [
                  TextContent('qOption',
                      '_______________________________________________________________________'),
                  TextContent('qOption',
                      '_______________________________________________________________________'),
                  TextContent('qOption',
                      '_______________________________________________________________________'),
                ]
                    : [
                  TextContent('qOption',
                      '_______________________________________________________________________')
                ]
                    : []));
        }).toList() ??
            []));
    return c;
  }

  static Future<bool> export(GForm form, {int startFrom = 0}) async {
    String? dir =
    await FilePicker.platform.saveFile(type: FileType.custom,
        allowedExtensions: ['docx'],
        fileName: '${form.documentTitle}.docx');
    if (dir != null) {
      try {
        print(dir);
        final data = await rootBundle.load('assets/template.docx');
        final bytes = data.buffer.asUint8List();
        final docx = await DocxTemplate.fromBytes(bytes);
        final file = File(dir);
        final c = buildDocx(form, startFrom: startFrom);
        final d = await docx.generate(c, tagPolicy: TagPolicy.removeAll);
        final res = await file.writeAsBytes(d!);
        return res.existsSync();
      } catch (e) {
        print(e);
        return false;
      }
    }
    return false;
  }
}
