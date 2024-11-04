import 'package:flutter/material.dart';

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
      await Future.delayed(const Duration(seconds: 2));
      _username = '';
      _email = '';
      _password = '';
      _isLoading = false;
      notifyListeners();

    } catch (e) {
      _errorMessage = 'An error occurred during registration';
      _isLoading = false;
      notifyListeners();
    }
  }
}
