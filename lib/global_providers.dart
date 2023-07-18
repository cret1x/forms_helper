import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forms_helper/state_notifiers/construct_notifier.dart';
import 'package:forms_helper/state_notifiers/selection_notifier.dart';
import 'package:forms_helper/state_notifiers/storage_notifier.dart';

import 'entities/question_item.dart';

final constructorProvider = StateNotifierProvider<
    ConstructorQuestionsStateNotifier,
    List<QuestionItem>>((ref) => ConstructorQuestionsStateNotifier());

final storageProvider = StateNotifierProvider<
    StorageQuestionsStateNotifier,
    List<QuestionItem>>((ref) => StorageQuestionsStateNotifier());

final constructorSelectionProvider = StateNotifierProvider<
    SelectionStateNotifier,
    bool>((ref) => SelectionStateNotifier());

final importSelectionProvider = StateNotifierProvider<
    SelectionStateNotifier,
    bool>((ref) => SelectionStateNotifier());