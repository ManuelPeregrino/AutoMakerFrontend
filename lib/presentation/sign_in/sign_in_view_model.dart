import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignInViewModel extends ChangeNotifier {
  String _username = '';
  String _password = '';
  bool _isLoading = false;
  bool _rememberMe = false;
  String? _errorMessage;

  String get username => _username;
  String get password => _password;
  bool get isLoading => _isLoading;
  bool get rememberMe => _rememberMe;
  String? get errorMessage => _errorMessage;

  void setUsername(String value) {
    _username = value;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    notifyListeners();
  }

  void setRememberMe(bool value) {
    _rememberMe = value;
    notifyListeners();
  }

  Future<void> signIn() async {
    if (_username.isEmpty || _password.isEmpty) {
      _errorMessage = "Please fill in all fields";
      notifyListeners();
      return;
    }

    _errorMessage = null;
    _isLoading = true;
    notifyListeners();

    final url = Uri.parse('[aca el endpoint]');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      'username': _username,
      'password': _password,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        String token = data['token'];

        _isLoading = false;
        _username = '';
        _password = '';
        _errorMessage = null;
        notifyListeners();

      } else {
        _errorMessage = 'Invalid username or password';
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'An error occurred during login';
      _isLoading = false;
      notifyListeners();
    }
  }
}
