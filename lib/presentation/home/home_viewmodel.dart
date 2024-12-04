import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:csv/csv.dart';

class HomeViewModel extends ChangeNotifier {
  String? _userId;
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _role;
  String? _accessToken;

  List<Printer> printers = [];
  bool isLoading = false;

  List<List<dynamic>> csvData = [];

  String? get userId => _userId;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get email => _email;
  String? get role => _role;

  HomeViewModel() {
    loadUserSession();
    // fetchPrinters();
  }

  Future<void> loadUserSession() async {
    final prefs = await SharedPreferences.getInstance();

    _userId = prefs.getString('userId');
    _firstName = prefs.getString('firstName');
    _lastName = prefs.getString('lastName');
    _email = prefs.getString('email');
    _role = prefs.getString('role');
    _accessToken = prefs.getString('accessToken');

    notifyListeners();
  }

  // Future<void> fetchPrinters() async {
  //   const String apiUrl = "https://your-api-url.com/printers";
  //   isLoading = true;
  //   notifyListeners();

  //   try {
  //     final response = await http.get(Uri.parse(apiUrl));
  //     if (response.statusCode == 200) {
  //       final List<dynamic> data = jsonDecode(response.body);
  //       printers = data.map((json) => Printer.fromJson(json)).toList();
  //     } else {
  //       throw Exception('Failed to load printers');
  //     }
  //   } catch (e) {
  //     debugPrint("Error fetching printers: $e");
  //   } finally {
  //     isLoading = false;
  //     notifyListeners();
  //   }
  // }

  Future<void> loadCsvFile(String filePath) async {
    try {
      final file = File(filePath);
      final content = await file.readAsString();
      final rows = const CsvToListConverter().convert(content);

      if (rows.isNotEmpty) {
        final desiredColumns = [
          'File name',
          'Timestamp',
          'Success',
          'Print time',
          'Filament length'
        ];
        final selectedIndexes = rows.first
            .asMap()
            .entries
            .where((entry) => desiredColumns.contains(entry.value))
            .map((entry) => entry.key)
            .toList();

        csvData = rows.map((row) {
          return selectedIndexes.map((index) => row[index]).toList();
        }).toList();

        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading CSV file: $e');
    }
  }

  Future<void> downloadCsvFile() async {
    const String apiUrl = "https://automakerapi.ngrok.app/api/upload_print_history";

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final directory = Directory.systemTemp;
        final filePath = '${directory.path}/print_history.csv';

        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        await loadCsvFile(filePath);
        notifyListeners();
      } else {
        throw Exception('Failed to download CSV: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("Error downloading CSV file: $e");
    }
  }

  void updateRowCost(List<dynamic> row, double cost) {
    row.add(cost);
    notifyListeners();
  }
}

class Printer {
  final String name;
  final String status;

  Printer({required this.name, required this.status});

  factory Printer.fromJson(Map<String, dynamic> json) {
    return Printer(
      name: json['name'] as String,
      status: json['status'] as String,
    );
  }
}
