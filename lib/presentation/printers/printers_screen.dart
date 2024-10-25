import 'package:flutter/material.dart';

class PrintersScreen extends StatelessWidget {
  const PrintersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Printers'),
      ),
      body: const Center(
        child: Text(
          'Printers Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
