import 'package:flutter/material.dart';
import '../printers/printers_list_view_model.dart';

class HomeViewModel extends ChangeNotifier {
  final String userName = "Eduardo VH";
  final String farmName = "Eduardo's Farm";

  final List<Printer> printers = [
    Printer(
      name: "Printer #1",
      status: "Online",
      progress: 75,
      extruderTemp: 200,
      bedTemp: 60,
      statusColor: Colors.green,
      icon: Icons.print,
    ),
    Printer(
      name: "Printer #2",
      status: "Offline",
      progress: 0,
      extruderTemp: 0,
      bedTemp: 0,
      statusColor: Colors.red,
      icon: Icons.error,
    ),
    Printer(
      name: "Printer #3",
      status: "Printing",
      progress: 40,
      extruderTemp: 210,
      bedTemp: 65,
      statusColor: Colors.blue,
      icon: Icons.print,
    ),
  ];

  void navigateToPrinters(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }
}
