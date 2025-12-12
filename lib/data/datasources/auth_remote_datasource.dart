// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:firebase_auth/firebase_auth.dart';

class AuthRemoteDataSource {
  // final ApiClient _apiClient = ApiClient(); // Reserved for future API integration
  // final GoogleSignIn _googleSignIn = GoogleSignIn();

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

  Future<bool> login(String email, String password) async {
    try {
      // Example API call structure
      // final response = await _apiClient.post(
      //   '/auth/login',
      //   data: {
      //     'email': email,
      //     'password': password,
      //   },
      // );
      // return response['success'] == true;

      // For demo purposes - accept any valid email/password
      // Demo credentials (optional - any email/password works):
      // Email: admin@recipe.com
      // Password: admin123
      //
      // Or use any email (with @) and password (6+ characters)
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      return true;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<bool> register(String name, String email, String password) async {
    try {
      // Example API call structure
      // final response = await _apiClient.post(
      //   '/auth/register',
      //   data: {
      //     'name': name,
      //     'email': email,
      //     'password': password,
      //   },
      // );
      // return response['success'] == true;

      // For demo purposes - accept any valid registration
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      return true;
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
