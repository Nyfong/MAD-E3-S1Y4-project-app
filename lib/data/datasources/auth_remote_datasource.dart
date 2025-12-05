import 'package:flutter/foundation.dart';
import 'package:rupp_final_mad/data/api/api_client.dart';
import 'package:rupp_final_mad/data/api/api_config.dart';
import 'package:rupp_final_mad/data/models/login_request.dart';
import 'package:rupp_final_mad/data/models/login_response.dart';
import 'package:rupp_final_mad/data/models/register_request.dart';
import 'package:rupp_final_mad/data/models/register_response.dart';

class AuthRemoteDataSource {
  final ApiClient _apiClient = ApiClient();

  // Lazy-loaded Firebase Auth to avoid initialization errors
  // FirebaseAuth? _firebaseAuth;

  // FirebaseAuth get firebaseAuth {
  //   try {
  //     _firebaseAuth ??= FirebaseAuth.instance;
  //     return _firebaseAuth!;
  //   } catch (e) {
  //     // Firebase not initialized - will use demo mode
  //     throw Exception('Firebase not initialized');
  //   }
  // }

  Future<LoginResponse> login(String email, String password) async {
    try {
      final request = LoginRequest(email: email, password: password);
      debugPrint('Login request: ${request.toJson()}');
      debugPrint('Login endpoint: ${ApiConfig.loginEndpoint}');
      debugPrint('Base URL: ${ApiConfig.baseUrl}');

      final response = await _apiClient.post(
        ApiConfig.loginEndpoint,
        data: request.toJson(),
      );

      debugPrint('Login response: $response');
      return LoginResponse.fromJson(response);
    } catch (e, stackTrace) {
      debugPrint('Login error: $e');
      debugPrint('Stack trace: $stackTrace');
      throw Exception('Login failed: $e');
    }
  }

  Future<RegisterResponse> register(
      String name, String email, String password) async {
    try {
      final request = RegisterRequest(
        email: email,
        displayName: name,
        photoUrl: '', // Default empty, can be updated later
        bio: '', // Default empty, can be updated later
        password: password,
      );

      final response = await _apiClient.post(
        ApiConfig.registerEndpoint,
        data: request.toJson(),
      );

      return RegisterResponse.fromJson(response);
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  Future<bool> loginWithGoogle() async {
    // TODO: Implement real Google Sign-In
    // try {
    //   // Trigger the authentication flow
    //   final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    //
    //   if (googleUser == null) {
    //     // User canceled the sign-in
    //     return false;
    //   }
    //
    //   // Obtain the auth details from the request
    //   final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    //
    //   // Create a new credential
    //   final credential = GoogleAuthProvider.credential(
    //     accessToken: googleAuth.accessToken,
    //     idToken: googleAuth.idToken,
    //   );
    //
    //   // Sign in to Firebase with the Google credential
    //   await firebaseAuth.signInWithCredential(credential);
    //
    //   // Call your backend API
    //   // final response = await _apiClient.post(
    //   //   '/auth/google',
    //   //   data: {
    //   //     'idToken': googleAuth.idToken,
    //   //     'accessToken': googleAuth.accessToken,
    //   //   },
    //   // );
    //   // return response['success'] == true;
    //
    //   return true;
    // } catch (e) {
    //   throw Exception('Google sign-in failed: $e');
    // }

    // Static demo implementation
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  Future<String?> sendPhoneOtp(String phoneNumber) async {
    // TODO: Implement real phone OTP sending
    // try {
    //   String? verificationId;
    //   String? errorMessage;
    //
    //   // Send OTP using Firebase Auth
    //   await firebaseAuth.verifyPhoneNumber(
    //     phoneNumber: phoneNumber,
    //     verificationCompleted: (PhoneAuthCredential credential) {
    //       // Auto-verification completed (Android only)
    //     },
    //     verificationFailed: (FirebaseAuthException e) {
    //       errorMessage = e.message;
    //     },
    //     codeSent: (String verId, int? resendToken) {
    //       verificationId = verId;
    //     },
    //     codeAutoRetrievalTimeout: (String verId) {
    //       verificationId = verId;
    //     },
    //     timeout: const Duration(seconds: 60),
    //   );
    //
    //   // Wait for callback
    //   await Future.delayed(const Duration(milliseconds: 500));
    //
    //   if (errorMessage != null) {
    //     throw Exception('Verification failed: $errorMessage');
    //   }
    //
    //   return verificationId;
    // } catch (e) {
    //   return null;
    // }

    // Static demo implementation
    await Future.delayed(const Duration(seconds: 1));
    return 'demo_verification_id_${DateTime.now().millisecondsSinceEpoch}';
  }

  Future<bool> verifyPhoneOtp(String verificationId, String otp) async {
    // TODO: Implement real phone OTP verification
    // try {
    //   // Create credential from verification ID and OTP
    //   final credential = PhoneAuthProvider.credential(
    //     verificationId: verificationId,
    //     smsCode: otp,
    //   );
    //
    //   // Sign in with the credential
    //   await firebaseAuth.signInWithCredential(credential);
    //
    //   // Call your backend API
    //   // final response = await _apiClient.post(
    //   //   '/auth/verify-phone',
    //   //   data: {
    //   //     'verificationId': verificationId,
    //   //     'otp': otp,
    //   //   },
    //   // );
    //   // return response['success'] == true;
    //
    //   return true;
    // } catch (e) {
    //   return false;
    // }

    // Static demo implementation - accept any 6-digit OTP
    await Future.delayed(const Duration(seconds: 1));
    return otp.length == 6;
  }

  Future<bool> logout() async {
    try {
      // TODO: Implement real logout
      // // Sign out from Google
      // await _googleSignIn.signOut();
      //
      // // Sign out from Firebase
      // await firebaseAuth.signOut();
      //
      // // Call your backend API
      // // final response = await _apiClient.post('/auth/logout');
      // // return response['success'] == true;

      // Static demo implementation
      return true;
    } catch (e) {
      return true;
    }
  }
}
