import 'package:flutter/foundation.dart';
import 'package:rupp_final_mad/data/api/api_client.dart';
import 'package:rupp_final_mad/data/api/api_config.dart';
import 'package:rupp_final_mad/data/models/recipe.dart';
import 'package:rupp_final_mad/data/services/fallback_data_service.dart';

class RecipeRemoteDataSource {
  final ApiClient _apiClient = ApiClient();

  Future<RecipesResponse> getRecipes({int page = 1, int limit = 20}) async {
    try {
      final response = await _apiClient.get(
        ApiConfig.recipesEndpoint(page: page, limit: limit),
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

      if (response.containsKey('payload')) {
        return Recipe.fromJson(response['payload'] as Map<String, dynamic>);
      }

      // If API returns only status/message, fall back to optimistic toggle
      if (currentRecipe != null) {
        return _toggleLocal(currentRecipe);
      }

      return Recipe.fromJson(response);
    } catch (e) {
      debugPrint('API like failed, using fallback toggle: $e');
      final fallback =
          currentRecipe ?? FallbackDataService.getFallbackRecipe(id);
      return _toggleLocal(fallback);
    }
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
      final response = await _apiClient.post(
        ApiConfig.recipeCreateEndpoint,
        data: data,
      );

      if (response.containsKey('payload')) {
        return Recipe.fromJson(response['payload'] as Map<String, dynamic>);
      }

      return Recipe.fromJson(response);
    } catch (e) {
      debugPrint('API create recipe failed: $e');
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
}
