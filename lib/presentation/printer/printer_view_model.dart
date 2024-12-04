import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PrinterViewModel extends ChangeNotifier {
  String printerName = "";
  String printStatus = "";
  double progress = 0.0;
  String remainingTime = "";
  String printerState = "Desconocido";
  String currentPrintTime = "N/A";

  double extruderTempCurrent = 0.0;
  double bedTempCurrent = 0.0;

  double filamentLength = 0.0;
  double filamentVolume = 0.0;

  List<int> weeklyPrints = [5, 10, 15, 20, 12, 8, 6]; // Datos de ejemplo

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Cargar datos de la impresora desde los endpoints
  Future<void> fetchPrinterData(String printerId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    const String tempUrl =
        'https://automakerapi.ngrok.app/printer/temperature/';
    const String statusUrl =
        'https://automakerapi.ngrok.app/status/';

    try {
      // Solicitar temperaturas
      final tempResponse = await http.get(Uri.parse(tempUrl));
      // Solicitar estado
      final statusResponse = await http.get(Uri.parse(statusUrl));

      if (tempResponse.statusCode == 200 && statusResponse.statusCode == 200) {
        final Map<String, dynamic> tempData = json.decode(tempResponse.body);
        final Map<String, dynamic> statusData =
            json.decode(statusResponse.body);

        // Datos de temperaturas
        extruderTempCurrent = (tempData['tool_temperature'] ?? 0).toDouble();
        bedTempCurrent = (tempData['bed_temperature'] ?? 0).toDouble();

        // Datos de estado
        printerState = statusData['state'] ?? "Desconocido";
        currentPrintTime = statusData['current_print_time'] != null
            ? statusData['current_print_time'].toString()
            : "N/A";

        // Valores adicionales para mostrar en la interfaz
        printerName = 'Impresora 1';
        printStatus =
            printerState == "Operational" ? "Operational" : "Printing";
        progress = printerState == "Operational" ? 0 : 75.0;
        remainingTime = printerState == "Operational" ? "N/A" : "00:45";

        filamentLength = 10.0;
        filamentVolume = 25.0;

        // Aquí puedes actualizar weeklyPrints si los datos vienen de un endpoint
        weeklyPrints = [5, 12, 8, 10, 15, 6, 4]; // Valores de prueba

        _isLoading = false;
        notifyListeners();
      } else {
        _errorMessage =
            "Error: ${tempResponse.reasonPhrase ?? 'Desconocido'} y ${statusResponse.reasonPhrase ?? 'Desconocido'}";
        _isLoading = false;
        notifyListeners();
      }
    } catch (e, stackTrace) {
      _errorMessage = "Error de red: $e";
      debugPrint("Detalles del error: $stackTrace");
      _isLoading = false;
      notifyListeners();
    }
  }
}
