import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_viewmodel.dart';
import '../widgets/ham_menu.dart';
import '../widgets/printer_item.dart';
import '../widgets/report_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel()..fetchPrinters(),
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
          builder: (context, viewModel, child) {
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
                            backgroundImage:
                                AssetImage('assets/profile_image.png'),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            viewModel.farmName,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            viewModel.userName,
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
                    ReportCard(
                      title: 'Gastos e Ingresos',
                      value: 'Placeholder',
                      borderColor: Colors.green,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Printers',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    viewModel.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 1,
                            ),
                            itemCount: viewModel.printers.length,
                            itemBuilder: (context, index) {
                              final printer = viewModel.printers[index];
                              return PrinterItem(
                                printerName: printer.name,
                                onTap: () => viewModel.navigateToPrinter(
                                    context, printer.id),
                              );
                            },
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
