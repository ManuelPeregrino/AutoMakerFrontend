import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  // Cargar datos de la impresora desde la API
  Future<void> fetchPrinterData(String printerId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    const String url =
        'https://25b1-189-150-29-105.ngrok-free.app/printer/temperature/'; // URL actualizada de la API

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // Actualizar los datos con la respuesta de la API
        extruderTempCurrent = (data['tool_temperature'] ?? 0).toDouble();
        extruderTempTarget = 0.0; // No disponible en la API
        bedTempCurrent = (data['bed_temperature'] ?? 0).toDouble();
        bedTempTarget = 0.0; // No disponible en la API

        // Datos de ejemplo, puedes agregarlos según lo que necesites
        printerName = 'Impresora 1';
        printStatus = 'Printing';
        progress = 75.0;
        remainingTime = "00:45";

        filamentLength = 10.0; // Valor de ejemplo
        filamentVolume = 25.0; // Valor de ejemplo

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
