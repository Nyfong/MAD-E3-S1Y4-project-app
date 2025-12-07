import 'dart:io';

class ApiConfig {
  // For Android emulator, use 10.0.2.2 instead of localhost
  // For iOS simulator, localhost works fine
  // For physical devices, use your computer's IP address (e.g., 192.168.1.100:8001)
  // Set to empty string to use fallback data
  static String get baseUrl {
    // Uncomment the line below and set to empty string to disable API and use fallback data
    // return '';

    if (Platform.isAndroid) {
      // Android emulator - use 10.0.2.2 to access host machine's localhost
      return 'http://10.0.2.2:8001/api/v1';
    } else if (Platform.isIOS) {
      // iOS simulator - localhost works
      return 'http://localhost:8001/api/v1';
    } else {
      // Desktop or other platforms
      return 'http://localhost:8001/api/v1';
    }
  }

  static bool get isApiEnabled => baseUrl.isNotEmpty;

  // Auth endpoints
  static const String registerEndpoint = '/auth/register';
  static const String loginEndpoint = '/auth/login';

  // User endpoints
  static const String userProfileEndpoint = '/users/me';

  // Recipe endpoints
  static String recipesEndpoint({int page = 1, int limit = 20}) =>
      '/recipes/?page=$page&limit=$limit';
  static String recipeDetailEndpoint(String id) => '/recipes/$id';
  static const String userRecipesEndpoint = '/users/me/recipes';
}



// aaa