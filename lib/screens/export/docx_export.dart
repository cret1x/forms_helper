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
  static Content buildDocx(GForm form, {int startFrom = 0}) {
    Content c = Content();
    c
      ..add(TextContent("title", form.title))
      ..add(TextContent("description", form.description))
      ..add(ListContent(
          "questions",
          form.items?.asMap().entries.map((e) {
                int idx = e.key + 1;
                FormItem val = e.value;
                return PlainContent('question')
                  ..add(TextContent('qtitle',
                      '${idx <= startFrom ? "" : "${idx - startFrom}. "}${val.title}'))
                  ..add(TextContent(
                      'pointValue',
                      (val is QuestionItem &&
                              val.required &&
                              val.pointValue > 0)
                          ? '(${val.pointValue} балл)'
                          : ''))
                  ..add(TextContent('qdescription', val.description))
                  ..add(ListContent(
                      'qOptions',
                      (val is ChoiceQuestion)
                          ? val.options
                              .map(
                                  (e) => TextContent('qOption', '□ ${e.value}'))
                              .toList()
                          : (val is TextQuestion)
                              ? (val.paragraph)
                                  ? [
                                      TextContent('qOption',
                                          '_____________________________________________________________________________'),
                                      TextContent('qOption',
                                          '_____________________________________________________________________________'),
                                      TextContent('qOption',
                                          '_____________________________________________________________________________'),
                                    ]
                                  : [
                                      TextContent('qOption',
                                          '_____________________________________________________________________________')
                                    ]
                              : []));
              }).toList() ??
              []));
    return c;
  }

  static Future<void> export(GForm form, {int startFrom = 0}) async {
    String? dir =
        await FilePicker.platform.saveFile(allowedExtensions: ['docx']);
    if (dir != null) {
      try {
        print(dir);
        final data = await rootBundle.load('assets/template.docx');
        final bytes = data.buffer.asUint8List();
        final docx = await DocxTemplate.fromBytes(bytes);
        final file = File(dir);
        final c = buildDocx(form, startFrom: startFrom);
        final d = await docx.generate(c);
        final res = await file.writeAsBytes(d!);
        print(res.existsSync());
      } catch (e) {
        print(e);
      }
    }
  }
}