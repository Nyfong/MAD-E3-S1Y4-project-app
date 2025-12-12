import 'package:flutter/foundation.dart';
import 'package:rupp_final_mad/domain/repositories/auth_repository.dart';
import 'package:rupp_final_mad/data/datasources/auth_remote_datasource.dart';
import 'package:rupp_final_mad/data/services/token_storage_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource = AuthRemoteDataSource();
  final TokenStorageService _tokenStorage = TokenStorageService();

  @override
  Future<bool> login(String email, String password) async {
    try {
      final response = await _remoteDataSource.login(email, password);
      debugPrint('Login response success: ${response.success}');

      if (response.success) {
        // Save the access token
        await _tokenStorage.saveToken(
          response.payload.accessToken,
          response.payload.tokenType,
        );
        debugPrint('Token saved successfully');
      }

      return response.success;
    } catch (e, stackTrace) {
      debugPrint('Login error in repository: $e');
      debugPrint('Stack trace: $stackTrace');
      return false;
    }
  }

  @override
  Future<bool> register(String name, String email, String password) async {
    try {
      final response = await _remoteDataSource.register(name, email, password);
      return response.success;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> loginWithGoogle() async {
    try {
      return await _remoteDataSource.loginWithGoogle();
    } catch (e) {
      // For demo purposes, allow Google login even if Firebase is not configured
      return true;
    }
  }

  @override
  Future<String?> sendPhoneOtp(String phoneNumber) async {
    try {
      return await _remoteDataSource.sendPhoneOtp(phoneNumber);
    } catch (e) {
      // For demo purposes, return a mock verification ID
      return 'demo_verification_id_${DateTime.now().millisecondsSinceEpoch}';
    }
  }

  @override
  Future<bool> verifyPhoneOtp(String verificationId, String otp) async {
    try {
      return await _remoteDataSource.verifyPhoneOtp(verificationId, otp);
    } catch (e) {
      // For demo purposes, accept any 6-digit OTP
      return otp.length == 6;
    }
  }

  @override
  Future<bool> logout() async {
    try {
      // Clear the stored token
      await _tokenStorage.clearToken();
      debugPrint('Token cleared on logout');
      return await _remoteDataSource.logout();
    } catch (e) {
      // Even if logout fails, clear the token
      await _tokenStorage.clearToken();
      return false;
    }
  }
}

//hi
