import 'package:flutter/material.dart';

class PrintersViewModel extends ChangeNotifier {
  final List<Printer> printers = [
    Printer(
      name: 'Printer 1',
      status: 'Printing',
      progress: 75,
      extruderTemp: 200,
      bedTemp: 60,
      statusColor: Colors.green,
      icon: Icons.print,
    ),
    Printer(
      name: 'Printer 2',
      status: 'Idle',
      progress: 0,
      extruderTemp: 25,
      bedTemp: 25,
      statusColor: Colors.greenAccent,
      icon: Icons.check_circle,
    ),
    Printer(
      name: 'Printer 3',
      status: 'Error',
      progress: 0,
      extruderTemp: 180,
      bedTemp: 55,
      statusColor: Colors.red,
      icon: Icons.error,
    ),
  ];
}

class Printer {
  final String name;
  final String status;
  final int progress;
  final int extruderTemp;
  final int bedTemp;
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
