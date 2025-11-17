import 'package:rupp_final_mad/domain/repositories/auth_repository.dart';
import 'package:rupp_final_mad/data/datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource = AuthRemoteDataSource();

  @override
  Future<bool> login(String email, String password) async {
    try {
      return await _remoteDataSource.login(email, password);
    } catch (e) {
      // For demo purposes, accept any email/password combination
      return true;
    }
  }

  @override
  Future<bool> register(String name, String email, String password) async {
    try {
      return await _remoteDataSource.register(name, email, password);
    } catch (e) {
      // For demo purposes, accept any registration
      return true;
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
      return await _remoteDataSource.logout();
    } catch (e) {
      return false;
    }
  }
}

