import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forms_helper/entities/answer.dart';
import 'package:forms_helper/entities/choice_question.dart';
import 'package:forms_helper/entities/form.dart';
import 'package:forms_helper/entities/question_item.dart';
import 'package:forms_helper/entities/text_question.dart';
import 'package:forms_helper/global_providers.dart';
import 'package:forms_helper/screens/construct.dart';
import 'package:forms_helper/screens/export/docx_export.dart';
import 'package:forms_helper/screens/export/pdf_export.dart';
import 'package:forms_helper/screens/import/import_widget.dart';
import 'package:forms_helper/screens/side_menu.dart';
import 'package:forms_helper/screens/storage/storage.dart';

import '../common/themes.dart';

class HomeWidget extends ConsumerStatefulWidget {
  const HomeWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends ConsumerState<HomeWidget> {
  final PageController _pageController = PageController();
  final SideMenuController _menuController = SideMenuController();

  @override
  void initState() {
    ref.read(disciplinesProvider.notifier).init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Themes.darkBlue,
      child: Scaffold(
        body: Row(
          children: [
            MenuWidget(
              pageController: _pageController,
              menuController: _menuController,
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                children: [
                  ImportWidget(
                    pageController: _pageController,
                    menuController: _menuController,
                  ),
                  StorageWidget(
                    pageController: _pageController,
                    menuController: _menuController,
                  ),
                  FormConstructor(
                    pageController: _pageController,
                    menuController: _menuController,
                  ),
                  Container(
                    color: Colors.green,
                    //TODO: change to normal export or delete
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          List<Answer> options = [
                            Answer(value: "Ответ 1"),
                            Answer(value: "Ответ 2"),
                            Answer(value: "Ответ 3"),
                            Answer(value: "Ответ 4"),
                          ];
                          List<QuestionItem> questions = [
                            TextQuestion(
                              id: '1',
                              title: 'Электронная почта',
                              description: '',
                              required: true,
                              pointValue: 0,
                              correctAnswers: [],
                              paragraph: false,
                              tag: null,
                            ),
                            TextQuestion(
                              id: '1',
                              title: 'Фамилия',
                              description: '',
                              required: true,
                              pointValue: 0,
                              correctAnswers: [],
                              paragraph: true,
                              tag: null,
                            ),
                            ChoiceQuestion(
                              id: '1',
                              title: 'Какие операции не обязательны при выполнении L1 регуляризации в нейронной сети?  ',
                              description: '',
                              required: true,
                              pointValue: 1,
                              correctAnswers: [options.first],
                              tag: null,
                              shuffle: false,
                              options: options,
                              type: QuestionType.RADIO,
                            ),
                            ChoiceQuestion(
                              id: '1',
                              title: 'Возможна ли ситуация, когда для одного слоя нейронной сети используют L1, а для другого слоя используют L2 регуляризацию?  ',
                              description: '',
                              required: true,
                              pointValue: 1,
                              correctAnswers: [...options],
                              tag: null,
                              shuffle: false,
                              options: options,
                              type: QuestionType.CHECKBOX,
                            ),
                            ChoiceQuestion(
                              id: '1',
                              title: 'В некоторой многослойной сети между двумя сверточными слоями добавили слой Dropout. Как изменилось число обучаемых параметров в этой сети, если размер выхода первого из этих слоев 28*28*3? ',
                              description: 'Описание вопроса три',
                              required: true,
                              pointValue: 1,
                              correctAnswers: [options.last],
                              tag: null,
                              shuffle: false,
                              options: options,
                              type: QuestionType.RADIO,
                            ),
                            ChoiceQuestion(
                              id: '1',
                              title: 'Вопрос 4',
                              description: 'Описание вопроса чотыре',
                              required: false,
                              pointValue: -1,
                              correctAnswers: [options.last],
                              tag: null,
                              shuffle: false,
                              options: options,
                              type: QuestionType.RADIO,
                            ),
                          ];
                          final form = GForm(
                              title: "Нейроматематика Экзамен (14.06.23)",
                              description:
                                  '''Экзаменационные вопросы по дисциплине "Нейроматематика".
Повторные ответы запрещены (принимается только первый по времени ответ).
Время выполнения теста - с 13:00 до 17:00.
Разрешается использование любой литературы.

Выберите один правильный или наиболее подходящий ответ.
Общая сумма баллов: 20
Оценка = сумма набранных баллов поделить на 2, округление к ближайшему целому.

(Для всех массивов канальная размерность - последняя).''',
                              documentTitle:
                                  'Нейроматематика Экзамен (14.06.23)',
                              items: questions);
                          await DocxExport.export(form, startFrom: 2);
                        },
                        child: const Text("EXPORT"),
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.orange,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
