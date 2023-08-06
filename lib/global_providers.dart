import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forms_helper/state_notifiers/question_list_notifier.dart';
import 'package:forms_helper/state_notifiers/discipline_notifier.dart';
import 'package:forms_helper/state_notifiers/form_info_notifier.dart';
import 'package:forms_helper/state_notifiers/manual_notifier.dart';
import 'package:forms_helper/state_notifiers/selection_notifier.dart';
import 'package:forms_helper/state_notifiers/selected_notifier.dart';

import 'entities/question_item.dart';
import 'entities/question_tag.dart';
import 'state_notifiers/numeration_notifier.dart';

final constructorQuestionsProvider = StateNotifierProvider<
    QuestionsStateNotifier,
    List<QuestionItem>>((ref) => QuestionsStateNotifier());

final constructorSelectedProvider =
    StateNotifierProvider<SelectedQuestionsStateNotifier, List<QuestionItem>>(
        (ref) => SelectedQuestionsStateNotifier());

final storageProvider =
    StateNotifierProvider<SelectedQuestionsStateNotifier, List<QuestionItem>>(
        (ref) => SelectedQuestionsStateNotifier());

final constructorSelectionProvider =
    StateNotifierProvider<SelectionStateNotifier, bool>(
        (ref) => SelectionStateNotifier());

final importSelectionProvider =
    StateNotifierProvider<SelectionStateNotifier, bool>(
        (ref) => SelectionStateNotifier());

final disciplinesProvider =
    StateNotifierProvider<DisciplinesListStateNotifier, List<Tag>>(
        (ref) => DisciplinesListStateNotifier());

final saveNotifierProvider =
    ChangeNotifierProvider<ManualNotifier>((ref) => ManualNotifier());

final formInfoProvider = ChangeNotifierProvider<FormInfoNotifier>((ref) => FormInfoNotifier());

final numerationProvider = ChangeNotifierProvider<NumerationNotifier>((ref) => NumerationNotifier());
