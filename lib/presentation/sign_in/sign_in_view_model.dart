import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'dart:typed_data'; // Necesario para manejar los bytes de la imagen

class SignInViewModel extends ChangeNotifier {
  String _email = '';
  String _password = '';
  bool _isLoading = false;
  bool _rememberMe = false;
  String? _errorMessage;
  String? _accessToken;
  Map<String, dynamic>? _userDetails;
  bool _isTwoFactorEnabled = false;
  Uint8List? _qrImageBytes; // Ahora guardamos los bytes de la imagen QR

  String get email => _email;
  String get password => _password;
  bool get isLoading => _isLoading;
  bool get rememberMe => _rememberMe;
  String? get errorMessage => _errorMessage;
  String? get accessToken => _accessToken;
  Map<String, dynamic>? get userDetails => _userDetails;
  bool get isTwoFactorEnabled => _isTwoFactorEnabled;
  Uint8List? get qrImageBytes => _qrImageBytes; // Devuelve los bytes

  void setEmail(String value) {
    _email = value;
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
    _errorMessage = null;
    _isLoading = true;
    notifyListeners();

    final url =
        Uri.parse('https://apiautomakerhost.serveirc.com/api/v1/auth/signIn');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      'email': _email,
      'password': _password,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 201) {
        final data = json.decode(response.body);

        // Verificar si el usuario está activo y si el código es correcto
        if (data['user']['active'] == true) {
          _accessToken = data['access_token'];
          _userDetails = data['user'];
          _isTwoFactorEnabled = data['user']['isTwoFactorEnable'];
          _isLoading = false;
          notifyListeners();
        } else {
          // Si el usuario no está activo o el código es incorrecto
          _errorMessage = 'Invalid authentication code or inactive user';
          _isLoading = false;
          notifyListeners();
        }
      } else {
        _errorMessage = 'Invalid email or password';
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Network error: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> generateQrCode() async {
    if (_accessToken == null) return;

    final url = Uri.parse(
        'https://apiautomakerhost.serveirc.com/api/v1/2fa/generate-qr');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_accessToken'
    };

    try {
      final response = await http.post(url, headers: headers);

      if (response.statusCode == 201) {
        _qrImageBytes = response.bodyBytes; // Guardamos los bytes de la imagen
        _errorMessage = null;
        notifyListeners();
      } else {
        _errorMessage = 'Failed to generate QR code';
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'An error occurred during QR generation';
      notifyListeners();
    }
  }

  Future<bool> verifyTwoFactorCode(String code) async {
    if (_accessToken == null) return false;

    if (!_isTwoFactorEnabled) {
      // Caso cuando 2FA aún no está habilitado
      final url = Uri.parse(
          'https://apiautomakerhost.serveirc.com/api/v1/2fa/turn-on-qr');
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_accessToken'
      };
      final body = json.encode({'code': code});

      try {
        final response = await http.post(url, headers: headers, body: body);

        if (response.statusCode == 201) {
          final data = json.decode(response.body);
          if (data['ok'] == true) {
            _isTwoFactorEnabled = true;
            _errorMessage = null;
            notifyListeners();
            return true;
          } else {
            _errorMessage = 'Invalid authentication code';
            notifyListeners();
            return false;
          }
        } else {
          _errorMessage = 'Failed to verify authentication code';
          notifyListeners();
          return false;
        }
      } catch (e) {
        _errorMessage = 'An error occurred during 2FA verification';
        notifyListeners();
        return false;
      }
    }
    return false;
  }

  Future<bool> authenticateTwoFactorCode(String code) async {
    if (_accessToken == null) {
      _errorMessage = 'Access token is missing';
      notifyListeners();
      return false;
    }

    final url = Uri.parse(
        'https://apiautomakerhost.serveirc.com/api/v1/2fa/authenticate');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_accessToken'
    };
    final body = json.encode({'code': code});

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 201) {
        final data = json.decode(response.body);

        // Verificar si el usuario está activo y si el código es correcto
        if (data['userDB']['active'] == true) {
          _errorMessage = null;
          notifyListeners();
          return true;
        } else {
          // Si el usuario no está activo o el código es incorrecto
          _errorMessage = 'Invalid authentication code or inactive user';
          notifyListeners();
          return false;
        }
      } else {
        _errorMessage = 'Failed to authenticate 2FA code';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'An error occurred during 2FA authentication';
      notifyListeners();
      return false;
    }
  }
}
