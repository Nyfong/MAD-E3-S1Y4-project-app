import 'dart:io';

class ApiConfig {
  /// Remote server base URL (forced)
  /// If you need localhost for development, change this value temporarily.
  static String get baseUrl => 'https://api-mad.procare.sbs/api/v1';

  static bool get isApiEnabled => baseUrl.isNotEmpty;

  // Auth endpoints
  static const String registerEndpoint = '/auth/register';
  static const String loginEndpoint = '/auth/login';

  // User endpoints
  static const String userProfileEndpoint = '/users/me';
  static const String uploadProfileImageEndpoint = '/users/me/profile-image';
  static const String deleteProfileImageEndpoint = '/users/me/profile-image';

  // Recipe endpoints
  static String recipesEndpoint({int page = 1, int limit = 20, String? cuisine}) {
    String endpoint = '/recipes/?page=$page&limit=$limit';
    if (cuisine != null && cuisine.isNotEmpty) {
      endpoint += '&cuisine=${Uri.encodeComponent(cuisine)}';
    }
    return endpoint;
  }
  static String recipeDetailEndpoint(String id) => '/recipes/$id';
  static String recipeLikeEndpoint(String id) => '/recipes/$id/like';
  static String recipeBookmarkEndpoint(String id) => '/recipes/$id/bookmark';
  static const String recipeCreateEndpoint = '/recipes/bulk';
  static const String userRecipesEndpoint = '/users/me/recipes';
  static const String bookmarkedRecipesEndpoint = '/recipes/bookmarked';
  
  // Upload endpoints
  static const String uploadRecipeImagesEndpoint = '/upload/recipe-images';
}



// aaa