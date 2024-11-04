import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'printer_view_model.dart';

class PrinterScreen extends StatelessWidget {
  const PrinterScreen({super.key, required printerName, required status, required progress, required extruderTemp, required bedTemp, required statusColor});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PrinterViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Printer'),
        ),
        body: Consumer<PrinterViewModel>(
          builder: (context, model, child) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: ListTile(
                      title: const Text('Estado de Impresión'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Progreso: ${model.progress}%'),
                          Text('Tiempo Restante: ${model.remainingTime}'),
                          Text(
                            'Estado: ${model.printStatus}',
                            style: TextStyle(
                                color: model.printStatus == 'Active'
                                    ? Colors.green
                                    : Colors.red),
                          ),
                        ],
                      ),
                      trailing: const Icon(Icons.print),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: ListTile(
                      title: const Text('Temperaturas'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Extrusor: ${model.extruderTempCurrent}°C / ${model.extruderTempTarget}°C'),
                          Text(
                              'Cama: ${model.bedTempCurrent}°C / ${model.bedTempTarget}°C'),
                        ],
                      ),
                      leading: const Icon(Icons.thermostat),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Historial de Impresiones'),
                          const SizedBox(height: 8),
                          Container(
                            height: 150,
                            color: Colors.grey[200],
                            child: const Center(
                              child: Text('Placeholder for Print History'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: ListTile(
                      title: const Text('Uso de Filamento'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Longitud: ${model.filamentLength} m'),
                          Text('Volumen: ${model.filamentVolume} cm³'),
                        ],
                      ),
                      leading: const Icon(Icons.category),
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
