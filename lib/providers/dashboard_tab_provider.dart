import 'package:flutter/material.dart';

class DashboardTabProvider extends ChangeNotifier {
  int currentIndex = 0;

  final List<String> tabs = [
    'Dashboard',
    'Map',
    'Categories',
    'Leads',
    'Messages',
    'Saved',
    'Profile',
    'Settings',
  ];

  void changeTab(int index) {
    currentIndex = index;
    notifyListeners();
  }
}
