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
          title: const Text('Detalles de la Impresora'),
          backgroundColor: Colors.blueGrey,
          elevation: 0,
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
                  style: const TextStyle(color: Colors.red, fontSize: 18),
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatusSection(model),
                  const SizedBox(height: 16),
                  _buildTemperatureSection(model),
                  const SizedBox(height: 16),
                  _buildFilamentUsageSection(model),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatusSection(PrinterViewModel model) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: model.printStatus == 'Operational'
            ? Colors.green.shade50
            : Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.print,
            size: 50,
            color:
                model.printStatus == 'Operational' ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Estado de Impresión',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
                const SizedBox(height: 8),
                Text('Progreso: ${model.progress}%',
                    style: const TextStyle(fontSize: 20)),
                Text('Tiempo Restante: ${model.remainingTime}',
                    style: const TextStyle(fontSize: 20)),
                Text(
                  'Estado: ${model.printStatus}',
                  style: TextStyle(
                    fontSize: 20,
                    color: model.printStatus == 'Operational'
                        ? Colors.green
                        : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemperatureSection(PrinterViewModel model) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.thermostat,
            size: 50,
            color: Colors.orange,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Temperaturas',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
                const SizedBox(height: 8),
                Text('Extrusor: ${model.extruderTempCurrent}°C',
                    style: const TextStyle(fontSize: 20)),
                Text('Cama: ${model.bedTempCurrent}°C',
                    style: const TextStyle(fontSize: 20)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilamentUsageSection(PrinterViewModel model) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.category,
            size: 50,
            color: Colors.blue,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Uso de Filamento',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
                const SizedBox(height: 8),
                Text('Longitud: ${model.filamentLength} m',
                    style: const TextStyle(fontSize: 20)),
                Text('Volumen: ${model.filamentVolume} cm³',
                    style: const TextStyle(fontSize: 20)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
