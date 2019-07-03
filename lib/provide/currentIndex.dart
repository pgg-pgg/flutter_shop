import 'package:flutter/material.dart';

class CurrentIndexProvide extends ChangeNotifier{
  int currentIndex = 0;
  changeIndex(int newIndex){
    currentIndex = newIndex;
    notifyListeners();
  }
}