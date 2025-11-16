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

  void logout() {
    _isAuthenticated = false;
    _userEmail = '';
    _userName = 'user';
    notifyListeners();
  }
}
