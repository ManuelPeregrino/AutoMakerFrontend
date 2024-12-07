import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  String _resetCode = '';
  String _newPassword = '';
  String _confirmPassword = '';
  bool _isResetCodeSent = false;

  bool get isResetCodeSent => _isResetCodeSent;

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

  @override
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

        if (data['user']['active'] == true) {
          _accessToken = data['access_token'];
          _userDetails = data['user'];
          _isTwoFactorEnabled = data['user']['isTwoFactorEnable'];

          // Save the user session
          await saveUserSession();

          _isLoading = false;
          notifyListeners();
        } else {
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
        final data = json.decode(response.body);
        if (data['qrCode'] != null) {
          _qrImageBytes = base64Decode(data['qrCode']); // Decodifica la imagen
          _errorMessage = null;
        } else {
          _qrImageBytes = null;
          _errorMessage = 'QR code not found in response';
        }
        notifyListeners();
      } else {
        _errorMessage = 'Failed to generate QR code';
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'An error occurred during QR generation: $e';
      notifyListeners();
    }
  }

  Future<bool> verifyTwoFactorCode(String code) async {
    if (_accessToken == null) return false;

    if (!_isTwoFactorEnabled) {
      // Caso cuando 2FA aún no está habilitado
      final url =
          Uri.parse('https://apiautomakerhost.serveirc.com/api/v1/2fa/turn-on');
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

  Future<bool> requestPasswordReset(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final url = Uri.parse(
        'https://apiautomakerhost.serveirc.com/api/v1/auth/request-reset-password');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({'email': email});

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 201) {
        _isResetCodeSent = true;
        _errorMessage = null;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Failed to send reset code';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Network error: $e';
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Reset password with code
  Future<bool> resetPasswordWithCode(
      String email, String code, String newPassword) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final url = Uri.parse(
        'https://apiautomakerhost.serveirc.com/api/v1/auth/reset-password');
    final headers = {'Content-Type': 'application/json'};
    final body =
        json.encode({'email': email, 'code': code, 'newPassword': newPassword});

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 201) {
        _errorMessage = null;
        _isResetCodeSent = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Failed to reset password';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Network error: $e';
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveUserSession() async {
    if (_userDetails == null || _accessToken == null) return;

    final prefs = await SharedPreferences.getInstance();

    // Save individual user details
    await prefs.setString('userId', _userDetails!['_id']);
    await prefs.setString('firstName', _userDetails!['firstName']);
    await prefs.setString('lastName', _userDetails!['lastName']);
    await prefs.setString('email', _userDetails!['email']);
    await prefs.setString('role', _userDetails!['role']);

    // Save access token
    await prefs.setString('accessToken', _accessToken!);
  }

  // New method to retrieve saved user session
  Future<Map<String, dynamic>?> getUserSession() async {
    final prefs = await SharedPreferences.getInstance();

    final userId = prefs.getString('userId');
    if (userId == null) return null;

    return {
      'userId': userId,
      'firstName': prefs.getString('firstName'),
      'lastName': prefs.getString('lastName'),
      'email': prefs.getString('email'),
      'role': prefs.getString('role'),
      'accessToken': prefs.getString('accessToken'),
    };
  }

  // New method to clear user session (logout)
  Future<void> clearUserSession() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('userId');
    await prefs.remove('firstName');
    await prefs.remove('lastName');
    await prefs.remove('email');
    await prefs.remove('role');
    await prefs.remove('accessToken');

    // Reset view model properties
    _accessToken = null;
    _userDetails = null;
    _isTwoFactorEnabled = false;
    _email = '';
    _password = '';

    notifyListeners();
  }
}
