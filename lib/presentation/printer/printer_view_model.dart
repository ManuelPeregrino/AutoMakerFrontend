import 'package:flutter/material.dart';

class PrinterViewModel extends ChangeNotifier {
  String printerName = "Printer #1";
  String printStatus = "Active";
  double progress = 75;
  String remainingTime = "1h 23m";

  double extruderTempCurrent = 210;
  double extruderTempTarget = 215;
  double bedTempCurrent = 60;
  double bedTempTarget = 60;

  double filamentLength = 345.5;
  double filamentVolume = 78.3;

  Map<String, int> printHistory = {
    "Mon": 4,
    "Tue": 8,
    "Wed": 6,
    "Thu": 5,
    "Fri": 7,
    "Sat": 3,
    "Sun": 2,
  };

  void updateProgress(double newProgress) {
    progress = newProgress;
    notifyListeners();
  }

}
