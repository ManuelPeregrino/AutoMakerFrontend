import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PrinterViewModel extends ChangeNotifier {
  String printerName = "";
  String printStatus = "";
  double progress = 0.0;
  String remainingTime = "";

  double extruderTempCurrent = 0.0;
  double extruderTempTarget = 0.0;
  double bedTempCurrent = 0.0;
  double bedTempTarget = 0.0;

  double filamentLength = 0.0;
  double filamentVolume = 0.0;

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchPrinterData(String printerId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final url =
        Uri.parse('https://exampleapi.com/api/v1/printer/$printerId'); // URL
    final headers = {'Content-Type': 'application/json'};

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        printerName = data['printerId'] ?? "";
        printStatus = data['printStatus'] ?? "";
        progress = (data['progress'] ?? 0).toDouble();
        remainingTime = data['remainingTime'] ?? "";

        extruderTempCurrent = (data['extruderTempCurrent'] ?? 0).toDouble();
        extruderTempTarget = (data['extruderTempTarget'] ?? 0).toDouble();
        bedTempCurrent = (data['bedTempCurrent'] ?? 0).toDouble();
        bedTempTarget = (data['bedTempTarget'] ?? 0).toDouble();

        filamentLength = (data['filamentLength'] ?? 0).toDouble();
        filamentVolume = (data['filamentVolume'] ?? 0).toDouble();

        _isLoading = false;
        notifyListeners();
      } else {
        _errorMessage = "Error: ${response.reasonPhrase}";
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = "Error de red: $e";
      _isLoading = false;
      notifyListeners();
    }
  }
}
