import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignUpViewModel extends ChangeNotifier {
  String _firstName = '';
  String _lastName = '';
  String _email = '';
  String _password = '';
  String _role = 'client';
  bool _active = true;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get email => _email;
  String get password => _password;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  // Setters
  void setFirstName(String value) {
    _firstName = value;
    notifyListeners();
  }

  void setLastName(String value) {
    _lastName = value;
    notifyListeners();
  }

  void setEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    notifyListeners();
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    return emailRegex.hasMatch(email);
  }

  Future<void> signUp() async {
    // Validaciones locales
    if (_firstName.isEmpty ||
        _lastName.isEmpty ||
        _email.isEmpty ||
        _password.isEmpty) {
      _errorMessage = "Please complete all fields";
      notifyListeners();
      return;
    }

    if (!_isValidEmail(_email)) {
      _errorMessage = "Invalid email format";
      notifyListeners();
      return;
    }

    if (_password.length < 8) {
      _errorMessage = "Password must be at least 8 characters long";
      notifyListeners();
      return;
    }

    _errorMessage = null;
    _isLoading = true;
    notifyListeners();

    final url = Uri.parse(
        'https://automakernot.serveirc.com/api/v1/auth/register'); // Reemplaza con tu URL
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'firstName': _firstName,
      'lastName': _lastName,
      'email': _email,
      'password': _password,
      'role': _role,
      'active': _active,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 201) {
        // Éxito
        _firstName = '';
        _lastName = '';
        _email = '';
        _password = '';
        _errorMessage = null;
      } else if (response.statusCode == 400) {
        // Errores de validación desde el servidor
        final responseData = jsonDecode(response.body);
        _errorMessage = responseData['message'] ?? 'Invalid input data';
      } else {
        // Otros errores del servidor
        _errorMessage = 'Email already exists. Please try again later.';
      }
    } catch (e) {
      // Errores de red
      _errorMessage = 'Network error: Please check your connection.';
    }

    _isLoading = false;
    notifyListeners();
  }
}
