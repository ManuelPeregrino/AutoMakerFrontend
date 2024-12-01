import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:csv/csv.dart';
import 'home_viewmodel.dart';
import '../widgets/ham_menu.dart';
import '../../routing/app_router.dart';

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
                          const SizedBox(height: 12),
                          Text(
                            'Granja Farm',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${homeViewModel.firstName ?? ''} ${homeViewModel.lastName ?? ''}'
                                    .trim()
                                    .isEmpty
                                ? 'Farm'
                                : '${homeViewModel.firstName} ${homeViewModel.lastName}',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Reports',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        final result = await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['csv'],
                        );
                        if (result != null && result.files.isNotEmpty) {
                          final filePath = result.files.single.path;
                          if (filePath != null) {
                            homeViewModel.loadCsvFile(filePath);
                          }
                        }
                      },
                      child: const Text('Cargar CSV'),
                    ),
                    const SizedBox(height: 16),
                    homeViewModel.csvData.isNotEmpty
                        ? SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columns: homeViewModel.csvData[0]
                                  .map<DataColumn>(
                                      (col) => DataColumn(label: Text(col)))
                                  .toList(),
                              rows: homeViewModel.csvData
                                  .skip(1)
                                  .map<DataRow>(
                                    (row) => DataRow(
                                      cells: row
                                          .map<DataCell>(
                                              (cell) => DataCell(Text(cell)))
                                          .toList(),
                                    ),
                                  )
                                  .toList(),
                            ),
                          )
                        : const Text('No se ha cargado ningún archivo CSV'),
                    const SizedBox(height: 24),
                    const Text(
                      'Printers',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.printers);
                      },
                      child: const Text('Ver impresoras'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
