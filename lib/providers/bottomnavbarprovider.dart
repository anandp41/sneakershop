import 'package:flutter/material.dart';

class BottomNavBarProvider extends ChangeNotifier {
  int currentIndex = 0;

  void setCurrentIndex({required int newIndex}) {
    currentIndex = newIndex;
    // notifyListeners();
  }

  void setCurrentIndexAndNotify({required int newIndex}) {
    currentIndex = newIndex;
    debugPrint('Before Notify');
    notifyListeners();
    debugPrint('After Notify');
  }
}
