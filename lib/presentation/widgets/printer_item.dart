import 'package:flutter/material.dart';

class PrinterItem extends StatelessWidget {
  final String printerName;
  final VoidCallback onTap;

  const PrinterItem({
    super.key,
    required this.printerName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: const DecorationImage(
            image: AssetImage('assets/printer_image.png'),
            fit: BoxFit.cover,
          ),
        ),
        alignment: Alignment.bottomCenter,
        child: Container(
          color: Colors.black54,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            printerName,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
