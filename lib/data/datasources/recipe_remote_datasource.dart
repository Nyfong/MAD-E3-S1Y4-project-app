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
}
