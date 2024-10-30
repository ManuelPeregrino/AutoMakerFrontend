import 'package:flutter/material.dart';

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

    try {
      await Future.delayed(const Duration(seconds: 2));

      if (_username == 'admin' && _password == 'admin') {
        _username = '';
        _password = '';
        _isLoading = false;
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
