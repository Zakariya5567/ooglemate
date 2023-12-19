import 'package:flutter/material.dart';

import '../helper/routes_helper.dart';

class BottomNavigationProvider extends ChangeNotifier {
  // Looking for bottom navigation state changes
  // current state/index of the navigation
  int currentIndex = 0;

  // method to change the state of the navigation
  setNavigationIndex(BuildContext context, int index) {
    currentIndex = index;
    print("index is : $currentIndex");
    notifyListeners();
  }
}
