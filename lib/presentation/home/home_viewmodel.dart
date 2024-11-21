import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Printer {
  final int id;
  final String name;

  Printer({required this.id, required this.name});

  factory Printer.fromJson(Map<String, dynamic> json) {
    return Printer(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}

class HomeViewModel extends ChangeNotifier {
  final String userName = "Eduardo VH";
  final String farmName = "Eduardo's Farm";
  List<Printer> printers = [];
  bool isLoading = false;

  Future<void> fetchPrinters() async {
    const String apiUrl = "https://your-api-url.com/printers"; // URL
    isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        printers = data.map((json) => Printer.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load printers');
      }
    } catch (e) {
      debugPrint("Error fetching printers: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void navigateToPrinter(BuildContext context, int printerId) {
    Navigator.pushNamed(context, '/printer', arguments: {'id': printerId});
  }
}
