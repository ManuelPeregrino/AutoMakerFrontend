import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  // sim data
  final String userName = "Eduardo VH";
  final String farmName = "Eduardo's Farm";
  final List<String> printers = ["Printer #1", "Printer #2", "Printer #3"];

  void navigateToPrinters(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }
}
