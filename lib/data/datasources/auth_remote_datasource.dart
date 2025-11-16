import 'package:rupp_final_mad/data/api/api_client.dart';

class AuthRemoteDataSource {
  final ApiClient _apiClient = ApiClient();

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

  Future<bool> logout() async {
    try {
      // Example API call structure
      // final response = await _apiClient.post('/auth/logout');
      // return response['success'] == true;

      // For demo purposes
      return true;
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }
}

