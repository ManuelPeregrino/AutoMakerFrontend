import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'printer_view_model.dart';

class PrinterScreen extends StatelessWidget {
  final String printerId;

  const PrinterScreen({super.key, required this.printerId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PrinterViewModel>(
      create: (_) {
        final viewModel = PrinterViewModel();
        viewModel.fetchPrinterData(printerId);
        return viewModel;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Printer'),
        ),
        body: Consumer<PrinterViewModel>(
          builder: (context, model, child) {
            if (model.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (model.errorMessage != null) {
              return Center(
                child: Text(
                  model.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: ListTile(
                      title: const Text('Print'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Progress: ${model.progress}%'),
                          Text('Remaining Time: ${model.remainingTime}'),
                          Text(
                            'Status: ${model.printStatus}',
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
                      title: const Text('Temperatures'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Extruder: ${model.extruderTempCurrent}°C / ${model.extruderTempTarget}°C'),
                          Text(
                              'Bed: ${model.bedTempCurrent}°C / ${model.bedTempTarget}°C'),
                        ],
                      ),
                      leading: const Icon(Icons.thermostat),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: ListTile(
                      title: const Text('Filament'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Length: ${model.filamentLength} m'),
                          Text('Volume: ${model.filamentVolume} cm³'),
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
