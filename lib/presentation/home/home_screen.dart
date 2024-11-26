import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_viewmodel.dart'; // Import the HomeViewModel
import '../widgets/ham_menu.dart';
import '../widgets/printer_item.dart';
import '../widgets/report_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(), // Initialize HomeViewModel
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
            // Checking if user session data is loaded
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
                    ReportCard(
                      title: 'Gastos e Ingresos',
                      value: 'Placeholder', // Replace with actual value
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
                    homeViewModel.isLoading
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
                            itemCount: homeViewModel.printers.length,
                            itemBuilder: (context, index) {
                              final printer = homeViewModel.printers[index];
                              return PrinterItem(
                                printerName: printer.name,
                                onTap: () => homeViewModel.navigateToPrinter(
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
