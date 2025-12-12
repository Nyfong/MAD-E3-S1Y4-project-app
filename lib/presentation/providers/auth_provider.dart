import 'package:flutter/foundation.dart';
import 'package:rupp_final_mad/domain/repositories/auth_repository.dart';
import 'package:rupp_final_mad/data/repositories/auth_repository_impl.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepositoryImpl();

  bool _isAuthenticated = false;
  String _userEmail = '';
  String _userName = 'user';

  bool get isAuthenticated => _isAuthenticated;
  String get userEmail => _userEmail;
  String get userName => _userName;

  Future<bool> login(String email, String password) async {
    try {
      final result = await _authRepository.login(email, password);
      if (result) {
        _isAuthenticated = true;
        _userEmail = email;
        _userName = email.split('@')[0]; // Extract username from email
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    try {
      final result = await _authRepository.register(name, email, password);
      if (result) {
        _isAuthenticated = true;
        _userEmail = email;
        _userName = name;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> loginWithGoogle() async {
    try {
      final result = await _authRepository.loginWithGoogle();
      if (result) {
        _isAuthenticated = true;
        // For demo, use a default email
        _userEmail = 'google.user@example.com';
        _userName = 'Google User';
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<String?> sendPhoneOtp(String phoneNumber) async {
    try {
      return await _authRepository.sendPhoneOtp(phoneNumber);
    } catch (e) {
      return null;
    }
  }

  Future<bool> verifyPhoneOtp(String verificationId, String otp) async {
    try {
      final result = await _authRepository.verifyPhoneOtp(verificationId, otp);
      if (result) {
        _isAuthenticated = true;
        _userEmail = 'phone.user@example.com';
        _userName = 'Phone User';
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  void logout() {
    _isAuthenticated = false;
    _userEmail = '';
    _userName = 'user';
    notifyListeners();
  }
}
