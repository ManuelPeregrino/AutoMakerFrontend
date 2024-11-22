import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileViewModel extends ChangeNotifier {
  final String baseUrl = ""; // URL

  bool _isConnecting = false;
  String? _octoprintUrl;
  String? _errorMessage;
  bool _isLoading = false;

  final TextEditingController _octoprintLinkController = TextEditingController();

  bool get isConnecting => _isConnecting;
  String? get octoprintUrl => _octoprintUrl;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  TextEditingController get octoprintLinkController => _octoprintLinkController;

  void toggleConnecting() {
    _isConnecting = !_isConnecting;
    notifyListeners();
  }

  Future<void> connectToOctoprint() async {
    _errorMessage = null;
    _isLoading = true;
    notifyListeners();

    final endpoint = Uri.parse('$baseUrl/connect-octoprint');
    final body = {
      'octoprintUrl': _octoprintLinkController.text.trim(),
    };

    try {
      final response = await http.post(
        endpoint,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _octoprintUrl = _octoprintLinkController.text.trim();
        _errorMessage = null;

        print('Conexión exitosa: ${data['message']}');
      } else {
        final errorData = json.decode(response.body);
        _errorMessage = errorData['error'] ?? 'Error al conectar con OctoPrint.';
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

  @override
  void dispose() {
    _octoprintLinkController.dispose();
    super.dispose();
  }
}
