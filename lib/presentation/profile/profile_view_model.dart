import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';

class ProfileViewModel extends ChangeNotifier {
  final String baseUrl =
      "https://automakergateway.serveirc.com/api"; // Updated base URL

  // User details
  String? _userId;
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _role;
  String? _accessToken;

  bool _isConnecting = false;
  String? _octoprintUrl;
  String? _errorMessage;
  bool _isLoading = false;
  bool _isLoadingReport = false;
  String? _reportErrorMessage;

  final TextEditingController _octoprintLinkController =
      TextEditingController();

  // Constructor to load user session on initialization
  ProfileViewModel() {
    loadUserSession();
  }

  // Getters for user details
  String? get userId => _userId;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get email => _email;
  String? get role => _role;

  // Existing getters
  bool get isConnecting => _isConnecting;
  String? get octoprintUrl => _octoprintUrl;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get isLoadingReport => _isLoadingReport;
  String? get reportErrorMessage => _reportErrorMessage;
  TextEditingController get octoprintLinkController => _octoprintLinkController;

  // Load user session from SharedPreferences
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

  // Logout method
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Reset all user-related properties
    _userId = null;
    _firstName = null;
    _lastName = null;
    _email = null;
    _role = null;
    _accessToken = null;

    notifyListeners();
  }

  void toggleConnecting() {
    _isConnecting = !_isConnecting;
    notifyListeners();
  }

  Future<void> connectToOctoprint() async {
    if (_accessToken == null) return;

    _errorMessage = null;
    _isLoading = true;
    notifyListeners();

    final endpoint = Uri.parse('$baseUrl/octoprint/connect');
    final body = {
      'octoprintUrl': _octoprintLinkController.text.trim(),
    };

    try {
      final response = await http.post(
        endpoint,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_accessToken',
        },
        body: json.encode(body),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        _octoprintUrl = _octoprintLinkController.text.trim();
        _errorMessage = null;
        print('Conexión exitosa: ${data['message']}');
      } else {
        final errorData = json.decode(response.body);
        _errorMessage =
            errorData['error'] ?? 'Error al conectar con OctoPrint.';
        print('Error: ${response.statusCode}, ${_errorMessage}');
      }
    } catch (e) {
      _errorMessage = 'Ocurrió un error: $e';
      print('Excepción: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> generateReport() async {
    if (_accessToken == null) return;

    _reportErrorMessage = null;
    _isLoadingReport = true;
    notifyListeners();

    final endpoint = Uri.parse('$baseUrl/report/generate');

    try {
      final response = await http.get(
        endpoint,
        headers: {
          'Authorization': 'Bearer $_accessToken',
        },
      );

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final file = File('/path/to/downloaded_report.pdf');
        await file.writeAsBytes(bytes);

        print('Reporte descargado exitosamente');
      } else {
        final errorData = json.decode(response.body);
        _reportErrorMessage =
            errorData['error'] ?? 'Error al generar el reporte.';
        print('Error: ${response.statusCode}, ${_reportErrorMessage}');
      }
    } catch (e) {
      _reportErrorMessage = 'Ocurrió un error: $e';
      print('Excepción: $e');
    } finally {
      _isLoadingReport = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _octoprintLinkController.dispose();
    super.dispose();
  }
}
