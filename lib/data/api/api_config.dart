import 'dart:io';

class ApiConfig {
  // Remote server URL
  // Set useLocalhost to true to use localhost instead
  static const bool useLocalhost = false;

  static String get baseUrl {
    // Uncomment the line below and set to empty string to disable API and use fallback data
    // return '';

    // Use remote server by default
    if (!useLocalhost) {
      return 'http://34.101.55.193:8000/api/v1';
    }

    // Localhost configuration (for development)
    if (Platform.isAndroid) {
      // Android emulator - use 10.0.2.2 to access host machine's localhost
      return 'http://10.0.2.2:8000/api/v1';
    } else if (Platform.isIOS) {
      // iOS simulator - localhost works
      return 'http://localhost:8000/api/v1';
    } else {
      // Desktop or other platforms
      return 'http://localhost:8000/api/v1';
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
  static String recipeLikeEndpoint(String id) => '/recipes/$id/like';
  static const String recipeCreateEndpoint = '/recipes/';
  static const String userRecipesEndpoint = '/users/me/recipes';
}



// aaa