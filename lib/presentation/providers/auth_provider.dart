import 'package:flutter/foundation.dart';
import 'package:rupp_final_mad/domain/repositories/auth_repository.dart';
import 'package:rupp_final_mad/data/repositories/auth_repository_impl.dart';
import 'package:rupp_final_mad/data/repositories/user_repository_impl.dart';
import 'package:rupp_final_mad/data/services/token_storage_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepositoryImpl();
  final UserRepositoryImpl _userRepository = UserRepositoryImpl();
  final TokenStorageService _tokenStorage = TokenStorageService();

  bool _isAuthenticated = false;
  String _userEmail = '';
  String _userName = 'user';
  bool _isCheckingAuth = false;

  bool get isAuthenticated => _isAuthenticated;
  String get userEmail => _userEmail;
  String get userName => _userName;
  bool get isCheckingAuth => _isCheckingAuth;

  Future<bool> login(String email, String password) async {
    try {
      final result = await _authRepository.login(email, password);
      if (result) {
        // Try to get user profile to get display name
        try {
          final profile = await _userRepository.getUserProfile();
          _userEmail = profile.email;
          _userName = profile.displayName.isNotEmpty
              ? profile.displayName
              : email.split('@')[0];
        } catch (e) {
          // If profile fetch fails, use email as fallback
          _userEmail = email;
          _userName = email.split('@')[0];
        }
        _isAuthenticated = true;
        notifyListeners();
        return true;
      }
      debugPrint('Login failed: result was false');
      return false;
    } catch (e, stackTrace) {
      debugPrint('Login exception: $e');
      debugPrint('Stack trace: $stackTrace');
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

  Future<void> logout() async {
    await _authRepository.logout();
    _isAuthenticated = false;
    _userEmail = '';
    _userName = 'user';
    notifyListeners();
  }

  /// Refresh user profile information
  Future<void> refreshUserProfile() async {
    try {
      final profile = await _userRepository.getUserProfile();
      _userEmail = profile.email;
      _userName = profile.displayName.isNotEmpty
          ? profile.displayName
          : profile.email.split('@')[0];
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to refresh user profile: $e');
    }
  }

  /// Check if user is authenticated by verifying stored token
  /// This should be called on app startup to restore authentication state
  Future<void> checkAuthStatus() async {
    _isCheckingAuth = true;
    notifyListeners();

    try {
      // Check if token exists
      final hasToken = await _tokenStorage.hasToken();
      if (!hasToken) {
        debugPrint('No token found, user not authenticated');
        _isAuthenticated = false;
        _isCheckingAuth = false;
        notifyListeners();
        return;
      }

      // Validate token by fetching user profile
      try {
        final profile = await _userRepository.getUserProfile();
        _isAuthenticated = true;
        _userEmail = profile.email;
        _userName = profile.displayName.isNotEmpty
            ? profile.displayName
            : profile.email.split('@')[0];
        debugPrint('Token validated, user authenticated: ${profile.email}');
      } catch (e) {
        // Token is invalid or expired
        debugPrint('Token validation failed: $e');
        // Clear invalid token
        await _tokenStorage.clearToken();
        _isAuthenticated = false;
        _userEmail = '';
        _userName = 'user';
      }
    } catch (e) {
      debugPrint('Error checking auth status: $e');
      _isAuthenticated = false;
    } finally {
      _isCheckingAuth = false;
      notifyListeners();
    }
  }
}
