abstract class AuthRepository {
  Future<bool> login(String email, String password);
  Future<bool> register(String name, String email, String password);
  Future<bool> loginWithGoogle();
  Future<String?> sendPhoneOtp(String phoneNumber);
  Future<bool> verifyPhoneOtp(String verificationId, String otp);
  Future<bool> logout();
}

