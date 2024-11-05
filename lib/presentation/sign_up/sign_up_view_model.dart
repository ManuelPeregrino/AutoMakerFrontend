import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignUpViewModel extends ChangeNotifier {
  String _username = '';
  String _email = '';
  String _password = '';
  bool _isLoading = false;
  String? _errorMessage;

  String get username => _username;
  String get email => _email;
  String get password => _password;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void setUsername(String value) {
    _username = value;
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

  Future<void> signUp() async {
    if (_username.isEmpty || _email.isEmpty || _password.isEmpty) {
      _errorMessage = "Please fill in all fields";
      notifyListeners();
      return;
    }

    _errorMessage = null;
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('[api url]'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': _username,
          'email': _email,
          'password': _password,
        }),
      );

      if (response.statusCode == 200) {
        _username = '';
        _email = '';
        _password = '';
        _errorMessage = null;
      } else {
        final responseData = jsonDecode(response.body);
        _errorMessage = responseData['message'] ?? 'Registration failed';
      }
    } catch (e) {
      _errorMessage = 'An error occurred during registration';
    }

    _isLoading = false;
    notifyListeners();
  }
}
