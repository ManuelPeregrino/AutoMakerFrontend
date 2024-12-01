import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:csv/csv.dart';

// Printer class
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
  // User session details
  String? _userId;
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _role;
  String? _accessToken;

  // Printers list and loading state
  List<Printer> printers = [];
  bool isLoading = false;

  // CSV data
  List<List<String>> csvData = [];

  // Getters for user details
  String? get userId => _userId;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get email => _email;
  String? get role => _role;

  // Constructor to load user session and printers
  HomeViewModel() {
    loadUserSession();
    fetchPrinters();
  }

  // Load user session from SharedPreferences
  Future<void> loadUserSession() async {
    final prefs = await SharedPreferences.getInstance();

    _userId = prefs.getString('userId');
    _firstName = prefs.getString('firstName');
    _lastName = prefs.getString('lastName');
    _email = prefs.getString('email');
    _role = prefs.getString('role');
    _accessToken = prefs.getString('accessToken');

    notifyListeners(); // Notify listeners when user session is loaded
  }

  // Fetch printers from API
  Future<void> fetchPrinters() async {
    const String apiUrl =
        "https://your-api-url.com/printers"; // API URL for fetching printers
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

  // Load CSV file and parse its content
  Future<void> loadCsvFile(String filePath) async {
    try {
      final file = File(filePath);
      final content = await file.readAsString();
      final rows = const CsvToListConverter().convert(content);

      csvData = rows
          .map((row) => row.map((cell) => cell.toString()).toList())
          .toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading CSV file: $e');
    }
  }

  // Navigate to Printer Details Screen
  void navigateToPrinter(BuildContext context, int printerId) {
    Navigator.pushNamed(context, '/printer', arguments: {'id': printerId});
  }

  // Logout method to clear session data
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear SharedPreferences

    // Reset user session data
    _userId = null;
    _firstName = null;
    _lastName = null;
    _email = null;
    _role = null;
    _accessToken = null;

    notifyListeners(); // Notify listeners that session has been cleared
  }
}
