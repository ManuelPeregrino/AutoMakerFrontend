import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../widgets/ham_menu.dart';
import 'home_viewmodel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Home'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
        ),
        drawer: const HamMenu(),
        body: Consumer<HomeViewModel>(
          builder: (context, homeViewModel, child) {
            if (homeViewModel.firstName == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          const CircleAvatar(
                            radius: 40,
                            backgroundImage: AssetImage('assets/app_icon.png'),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${homeViewModel.firstName ?? ''} ${homeViewModel.lastName ?? ''}'
                                    .trim()
                                    .isEmpty
                                ? 'Farm'
                                : '${homeViewModel.firstName} ${homeViewModel.lastName}',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'History',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        // ElevatedButton(
                        //   onPressed: () async {
                        //     final result = await FilePicker.platform.pickFiles(
                        //       type: FileType.custom,
                        //       allowedExtensions: ['csv'],
                        //     );
                        //     if (result != null && result.files.isNotEmpty) {
                        //       final filePath = result.files.single.path;
                        //       if (filePath != null) {
                        //         homeViewModel.loadCsvFile(filePath);
                        //       }
                        //     }
                        //   },
                        //   style: ElevatedButton.styleFrom(
                        //     foregroundColor: Colors.white,
                        //     backgroundColor: Colors.orange,
                        //   ),
                        //   child: const Text('Cargar CSV'),
                        // ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () async {
                            await homeViewModel.downloadCsvFile();
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          child: const Text('Descargar CSV'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    homeViewModel.csvData.isNotEmpty
                        ? SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columns: [
                                ...homeViewModel.csvData.first
                                    .map((header) => DataColumn(
                                          label: Text(header.toString()),
                                        )),
                                const DataColumn(
                                  label: Text('Calculate Price'),
                                ),
                              ],
                              rows: homeViewModel.csvData.skip(1).map<DataRow>(
                                (row) {
                                  return DataRow(
                                    cells: [
                                      ...row.map((cell) => DataCell(
                                            Text(cell.toString()),
                                          )),
                                      DataCell(
                                        IconButton(
                                          icon: const Icon(Icons.calculate),
                                          onPressed: () {
                                            _showCostCalculatorPopup(
                                              context,
                                              row[4],
                                              homeViewModel,
                                              row,
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ).toList(),
                            ),
                          )
                        : const Text('No se ha cargado ningún archivo CSV'),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showCostCalculatorPopup(BuildContext context, String filamentLength,
      HomeViewModel homeViewModel, List<dynamic> row) {
    final TextEditingController priceController = TextEditingController();
    final TextEditingController lengthController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Calculate Cost'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: priceController,
                decoration: const InputDecoration(
                  labelText: 'Spool Price (MXN)',
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: lengthController,
                decoration: const InputDecoration(
                  labelText: 'Filament Spool Weight (KG)',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                final price = double.tryParse(priceController.text);
                final spoolWeight = double.tryParse(lengthController.text);

                if (price == null ||
                    spoolWeight == null ||
                    price <= 0 ||
                    spoolWeight <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Por favor, ingresa valores válidos para precio y longitud del rollo.'),
                    ),
                  );
                  return;
                }

                final filamentLengthMM = double.tryParse(filamentLength);
                if (filamentLengthMM == null || filamentLengthMM <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'La longitud del filamento no es válida: "$filamentLength".',
                      ),
                    ),
                  );
                  return;
                }

                const avgSpoolLength = 330;

                final costPerMM = price / (spoolWeight * (avgSpoolLength * 1000));
                final totalCost = filamentLengthMM * costPerMM;

                homeViewModel.updateRowCost(row, totalCost);

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Costo de impresión: \$${totalCost.toStringAsFixed(2)}',
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white),
              child: const Text('Calcular'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[400],
                  foregroundColor: Colors.white),
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }
}
