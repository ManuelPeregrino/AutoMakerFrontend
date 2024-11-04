import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'printers_list_view_model.dart';

class PrintersListScreen extends StatelessWidget {
  const PrintersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PrintersListViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Eduardo’s Farm'),
        ),
        body: Consumer<PrintersListViewModel>(
          builder: (context, model, child) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Printer Reports',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: model.printers.length,
                      itemBuilder: (context, index) {
                        final printer = model.printers[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(printer.icon, color: printer.statusColor, size: 28),
                                    const SizedBox(width: 8),
                                    Text(
                                      printer.name,
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Status: ${printer.status}',
                                  style: TextStyle(color: printer.statusColor),
                                ),
                                const SizedBox(height: 4),
                                Text('${printer.progress}% Complete', style: TextStyle(color: Colors.green)),
                                const SizedBox(height: 4),
                                LinearProgressIndicator(
                                  value: printer.progress / 100,
                                  backgroundColor: Colors.grey[300],
                                  valueColor: AlwaysStoppedAnimation<Color>(printer.statusColor),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Extruder Temp: ${printer.extruderTemp}°C'),
                                    Text('Bed Temp: ${printer.bedTemp}°C'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
