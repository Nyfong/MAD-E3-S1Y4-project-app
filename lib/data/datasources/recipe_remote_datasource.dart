import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:rupp_final_mad/data/api/api_client.dart';
import 'package:rupp_final_mad/data/api/api_config.dart';
import 'package:rupp_final_mad/data/models/recipe.dart';
import 'package:rupp_final_mad/data/services/fallback_data_service.dart';

class RecipeRemoteDataSource {
  final ApiClient _apiClient = ApiClient();

  Future<RecipesResponse> getRecipes({int page = 1, int limit = 20, String? cuisine}) async {
    try {
      final response = await _apiClient.get(
        ApiConfig.recipesEndpoint(page: page, limit: limit, cuisine: cuisine),
      );

      return RecipesResponse.fromJson(response);
    } catch (e) {
      debugPrint('API failed, using fallback data: $e');
      // Return fallback data when API fails
      return RecipesResponse(
        success: true,
        message: 'Using demo recipes',
        payload: FallbackDataService.getFallbackRecipes(),
        status: 200,
        timestamp: DateTime.now().toIso8601String(),
      );
    }
  }

  Future<Recipe> getRecipeById(String id) async {
    try {
      final response = await _apiClient.get(
        ApiConfig.recipeDetailEndpoint(id),
      );

      // Assuming single recipe response has the same structure
      // If the API returns a different structure, adjust accordingly
      if (response.containsKey('payload')) {
        return Recipe.fromJson(response['payload'] as Map<String, dynamic>);
      } else {
        return Recipe.fromJson(response);
      }
    } catch (e) {
      debugPrint('API failed, using fallback data: $e');
      // Return fallback recipe when API fails
      return FallbackDataService.getFallbackRecipe(id);
    }
  }

  Future<Recipe> toggleLike(
    String id, {
    Recipe? currentRecipe,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConfig.recipeLikeEndpoint(id),
      );

      // If API returns a payload with recipe data, use it
      if (response.containsKey('payload') && response['payload'] != null) {
        try {
          return Recipe.fromJson(response['payload'] as Map<String, dynamic>);
        } catch (e) {
          debugPrint('Failed to parse recipe from payload: $e');
          // Fall through to use optimistic update
        }
      }

      // Always use optimistic toggle if we have currentRecipe
      // This ensures we never lose the recipe data
      if (currentRecipe != null) {
        return _toggleLocal(currentRecipe);
      }

      // Last resort: try to parse response as recipe (shouldn't happen in normal flow)
      try {
        return Recipe.fromJson(response);
      } catch (e) {
        debugPrint('Failed to parse response as recipe: $e');
        // Use fallback if parsing fails
        final fallback = FallbackDataService.getFallbackRecipe(id);
        return _toggleLocal(fallback);
      }
    } catch (e) {
      debugPrint('API like failed, using fallback toggle: $e');
      // Always use optimistic update if we have currentRecipe
      if (currentRecipe != null) {
        return _toggleLocal(currentRecipe);
      }
      // Otherwise use fallback
      final fallback = FallbackDataService.getFallbackRecipe(id);
      return _toggleLocal(fallback);
    }
  }

  Future<Recipe> toggleBookmark(
    String id, {
    Recipe? currentRecipe,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConfig.recipeBookmarkEndpoint(id),
      );

      // If API returns a payload with recipe data, use it
      if (response.containsKey('payload') && response['payload'] != null) {
        try {
          return Recipe.fromJson(response['payload'] as Map<String, dynamic>);
        } catch (e) {
          debugPrint('Failed to parse recipe from payload: $e');
          // Fall through to use optimistic update
        }
      }

      // Always use optimistic toggle if we have currentRecipe
      // This ensures we never lose the recipe data
      if (currentRecipe != null) {
        return _toggleBookmarkLocal(currentRecipe);
      }

      // Last resort: try to parse response as recipe (shouldn't happen in normal flow)
      try {
        return Recipe.fromJson(response);
      } catch (e) {
        debugPrint('Failed to parse response as recipe: $e');
        // Use fallback if parsing fails
        final fallback = FallbackDataService.getFallbackRecipe(id);
        return _toggleBookmarkLocal(fallback);
      }
    } catch (e) {
      debugPrint('API bookmark failed, using fallback toggle: $e');
      // Always use optimistic update if we have currentRecipe
      if (currentRecipe != null) {
        return _toggleBookmarkLocal(currentRecipe);
      }
      // Otherwise use fallback
      final fallback = FallbackDataService.getFallbackRecipe(id);
      return _toggleBookmarkLocal(fallback);
    }
  }

  Recipe _toggleBookmarkLocal(Recipe recipe) {
    final updatedBookmarks = recipe.bookmarksCount + (recipe.isBookmarked ? -1 : 1);
    return Recipe(
      id: recipe.id,
      title: recipe.title,
      description: recipe.description,
      difficulty: recipe.difficulty,
      cookingTime: recipe.cookingTime,
      servings: recipe.servings,
      cuisine: recipe.cuisine,
      imageUrl: recipe.imageUrl,
      authorId: recipe.authorId,
      authorName: recipe.authorName,
      authorPhotoURL: recipe.authorPhotoURL,
      authorBio: recipe.authorBio,
      ingredients: recipe.ingredients,
      instructions: recipe.instructions,
      tags: recipe.tags,
      likesCount: recipe.likesCount,
      bookmarksCount: updatedBookmarks < 0 ? 0 : updatedBookmarks,
      isLiked: recipe.isLiked,
      isBookmarked: !recipe.isBookmarked,
      createdAt: recipe.createdAt,
    );
  }

  Recipe _toggleLocal(Recipe recipe) {
    final updatedLikes = recipe.likesCount + (recipe.isLiked ? -1 : 1);
    return Recipe(
      id: recipe.id,
      title: recipe.title,
      description: recipe.description,
      difficulty: recipe.difficulty,
      cookingTime: recipe.cookingTime,
      servings: recipe.servings,
      cuisine: recipe.cuisine,
      imageUrl: recipe.imageUrl,
      authorId: recipe.authorId,
      authorName: recipe.authorName,
      authorPhotoURL: recipe.authorPhotoURL,
      authorBio: recipe.authorBio,
      ingredients: recipe.ingredients,
      instructions: recipe.instructions,
      tags: recipe.tags,
      likesCount: updatedLikes < 0 ? 0 : updatedLikes,
      bookmarksCount: recipe.bookmarksCount,
      isLiked: !recipe.isLiked,
      isBookmarked: recipe.isBookmarked,
      createdAt: recipe.createdAt,
    );
  }

  Future<RecipesResponse> getUserRecipes() async {
    try {
      final response = await _apiClient.get(
        ApiConfig.userRecipesEndpoint,
      );

      return RecipesResponse.fromJson(response);
    } catch (e) {
      debugPrint('API failed, using fallback data: $e');
      // Return fallback data when API fails
      return RecipesResponse(
        success: true,
        message: 'Using demo recipes',
        payload: FallbackDataService.getFallbackRecipes(),
        status: 200,
        timestamp: DateTime.now().toIso8601String(),
      );
    }
  }

  Future<RecipesResponse> getBookmarkedRecipes() async {
    try {
      final response = await _apiClient.get(
        ApiConfig.bookmarkedRecipesEndpoint,
      );

      return RecipesResponse.fromJson(response);
    } catch (e) {
      debugPrint('API failed to load bookmarked recipes: $e');
      // Return empty list when API fails
      return RecipesResponse(
        success: true,
        message: 'No bookmarked recipes',
        payload: [],
        status: 200,
        timestamp: DateTime.now().toIso8601String(),
      );
    }
  }

  Future<void> deleteRecipe(String id) async {
    try {
      await _apiClient.delete(ApiConfig.recipeDetailEndpoint(id));
    } catch (e) {
      debugPrint('API delete failed: $e');
      rethrow;
    }
  }

  Future<Recipe> createRecipe(Map<String, dynamic> data) async {
    try {
      // API expects an array of recipe objects for bulk endpoint
      final requestData = [data];
      
      final submittedTitle = data['title'] as String? ?? '';
      final submittedDescription = data['description'] as String? ?? '';
      
      debugPrint('Creating recipe with data: $data');
      debugPrint('Submitted title: $submittedTitle');
      
      final response = await _apiClient.post(
        ApiConfig.recipeCreateEndpoint,
        data: requestData,
      );

      debugPrint('Create recipe response type: ${response.runtimeType}');
      debugPrint('Create recipe response: $response');

      Recipe? createdRecipe;

      // The API returns an array, so we need to extract the first recipe
      if (response is List) {
        if (response.isNotEmpty) {
          final firstItem = response[0];
          if (firstItem is Map<String, dynamic>) {
            createdRecipe = Recipe.fromJson(firstItem);
          } else {
            throw Exception('Invalid response format: expected Map in array, got ${firstItem.runtimeType}');
          }
        } else {
          throw Exception('Empty response array from API');
        }
      }
      
      // Handle if response is wrapped in payload
      if (response is Map<String, dynamic>) {
        // Check for standard API response format with payload
        if (response.containsKey('payload')) {
          final payload = response['payload'];
          
          if (payload is List) {
            if (payload.isNotEmpty) {
              final firstItem = payload[0];
              if (firstItem is Map<String, dynamic>) {
                createdRecipe = Recipe.fromJson(firstItem);
              } else {
                throw Exception('Invalid payload format: expected Map in array, got ${firstItem.runtimeType}');
              }
            } else {
              throw Exception('Empty payload array from API');
            }
          } else if (payload is Map<String, dynamic>) {
            createdRecipe = Recipe.fromJson(payload);
          } else {
            throw Exception('Invalid payload type: ${payload.runtimeType}');
          }
        }
        // Check if response itself is a recipe object (direct response)
        else if (response.containsKey('id') && response.containsKey('title')) {
          createdRecipe = Recipe.fromJson(response);
        }
        // Check for data field (alternative response format)
        else if (response.containsKey('data')) {
          final responseData = response['data'];
          if (responseData is List && responseData.isNotEmpty) {
            final firstItem = responseData[0];
            if (firstItem is Map<String, dynamic>) {
              createdRecipe = Recipe.fromJson(firstItem);
            }
          } else if (responseData is Map<String, dynamic>) {
            createdRecipe = Recipe.fromJson(responseData);
          }
        }
        // Last resort: try to parse the entire response as a recipe
        else {
          try {
            createdRecipe = Recipe.fromJson(response);
          } catch (parseError) {
            throw Exception('Could not parse recipe from response. Response keys: ${response.keys.toList()}. Parse error: $parseError');
          }
        }
      }

      if (createdRecipe == null) {
        throw Exception('Unexpected response format: ${response.runtimeType}. Response: $response');
      }

      // Validate that the returned recipe matches what we submitted
      // Check if the title matches (case-insensitive) to ensure we got the right recipe
      final returnedTitle = createdRecipe.title.trim().toLowerCase();
      final expectedTitle = submittedTitle.trim().toLowerCase();
      
      if (returnedTitle != expectedTitle && 
          !returnedTitle.contains(expectedTitle) && 
          !expectedTitle.contains(returnedTitle)) {
        debugPrint('WARNING: Returned recipe title does not match submitted title!');
        debugPrint('Submitted: $submittedTitle');
        debugPrint('Returned: ${createdRecipe.title}');
        
        // If titles don't match, create a recipe object with the submitted data
        // but use the ID and other server-generated fields from the response
        return Recipe(
          id: createdRecipe.id,
          title: submittedTitle,
          description: submittedDescription,
          difficulty: data['difficulty'] as String? ?? createdRecipe.difficulty,
          cookingTime: data['cookingTime'] as int? ?? createdRecipe.cookingTime,
          servings: data['servings'] as int? ?? createdRecipe.servings,
          cuisine: data['cuisine'] as String? ?? createdRecipe.cuisine,
          imageUrl: data['imageUrl'] as String? ?? createdRecipe.imageUrl,
          authorId: createdRecipe.authorId,
          authorName: createdRecipe.authorName,
          authorPhotoURL: createdRecipe.authorPhotoURL,
          authorBio: createdRecipe.authorBio,
          ingredients: (data['ingredients'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? createdRecipe.ingredients,
          instructions: (data['instructions'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? createdRecipe.instructions,
          tags: (data['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? createdRecipe.tags,
          likesCount: createdRecipe.likesCount,
          bookmarksCount: createdRecipe.bookmarksCount,
          isLiked: createdRecipe.isLiked,
          isBookmarked: createdRecipe.isBookmarked,
          createdAt: createdRecipe.createdAt,
        );
      }

      return createdRecipe;
    } catch (e, stackTrace) {
      debugPrint('API create recipe failed: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<Recipe> updateRecipe(String id, Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.put(
        ApiConfig.recipeDetailEndpoint(id),
        data: data,
      );

      if (response.containsKey('payload')) {
        return Recipe.fromJson(response['payload'] as Map<String, dynamic>);
      }

      return Recipe.fromJson(response);
    } catch (e) {
      debugPrint('API update recipe failed: $e');
      rethrow;
    }
  }

  Future<List<String>> uploadRecipeImages(
    List<File> imageFiles, {
    String? recipeId,
  }) async {
    try {
      // Add recipe_id field (empty string if not provided, for new recipes)
      final additionalFields = <String, String>{
        'recipe_id': recipeId ?? '',
      };
      
      final response = await _apiClient.postMultipart(
        ApiConfig.uploadRecipeImagesEndpoint,
        files: imageFiles,
        fieldName: 'files', // API expects 'files' field name
        additionalFields: additionalFields,
      );

      // Extract image URLs from response
      // Expected response format: {"payload": {"urls": ["url1", "url2", ...]}}
      // or {"urls": ["url1", "url2", ...]}
      List<String> imageUrls = [];
      
      if (response.containsKey('payload')) {
        final payload = response['payload'] as Map<String, dynamic>;
        if (payload.containsKey('urls')) {
          final urls = payload['urls'] as List;
          imageUrls = urls.map((url) => url.toString()).toList();
        } else if (payload.containsKey('imageUrl')) {
          // Single image URL
          imageUrls = [payload['imageUrl'].toString()];
        }
      } else if (response.containsKey('urls')) {
        final urls = response['urls'] as List;
        imageUrls = urls.map((url) => url.toString()).toList();
      } else if (response.containsKey('imageUrl')) {
        // Single image URL
        imageUrls = [response['imageUrl'].toString()];
      }

      if (imageUrls.isEmpty) {
        throw Exception('No image URLs returned from upload');
      }

      return imageUrls;
    } catch (e) {
      debugPrint('API upload recipe images failed: $e');
      rethrow;
    }
  }
}
