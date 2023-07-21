import 'package:flutter/cupertino.dart';

class ManualNotifier with ChangeNotifier {
  void notify() {
    notifyListeners();
  }
}