import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PrintersListViewModel extends ChangeNotifier {
  List<Printer> printers = [];

  PrintersListViewModel() {
    _loadPrinterData();
  }

  // Función para cargar los datos de la API
  Future<void> _loadPrinterData() async {
    const String url =
        'https://2e5a-189-150-29-105.ngrok-free.app/printer/temperature/';

    try {
      final response = await http.get(Uri.parse(url));

      print('Response status: ${response.statusCode}');
      print(
          'Response body: ${response.body}'); // Imprimir el cuerpo de la respuesta

      if (response.statusCode == 200) {
        // Si la solicitud fue exitosa, parseamos la respuesta JSON
        final Map<String, dynamic> data = json.decode(response.body);

        // Usamos los datos recibidos para actualizar las impresoras
        printers = [
          Printer(
            name: 'Printer 1',
            status: 'Printing',
            progress: 75,
            extruderTemp: data['tool_temperature']
                .toDouble(), // Usamos el valor de la API como double
            bedTemp: data['bed_temperature']
                .toDouble(), // Usamos el valor de la API como double
            statusColor: Colors.green,
            icon: Icons.print,
          ),
          Printer(
            name: 'Printer 2',
            status: 'Idle',
            progress: 0,
            extruderTemp: 25.0,
            bedTemp: 25.0,
            statusColor: Colors.greenAccent,
            icon: Icons.check_circle,
          ),
          Printer(
            name: 'Printer 3',
            status: 'Error',
            progress: 0,
            extruderTemp: 180.0,
            bedTemp: 55.0,
            statusColor: Colors.red,
            icon: Icons.error,
          ),
        ];

        // Notificamos a los oyentes que los datos se han actualizado
        notifyListeners();
      } else {
        // Manejo de errores en caso de que la respuesta no sea exitosa
        throw Exception('Failed to load printer data');
      }
    } catch (e) {
      print('Error loading printer data: $e');
    }
  }
}

class Printer {
  final String name;
  final String status;
  final int progress;
  final double extruderTemp; // Cambio a double
  final double bedTemp; // Cambio a double
  final Color statusColor;
  final IconData icon;

  Printer({
    required this.name,
    required this.status,
    required this.progress,
    required this.extruderTemp,
    required this.bedTemp,
    required this.statusColor,
    required this.icon,
  });
}
