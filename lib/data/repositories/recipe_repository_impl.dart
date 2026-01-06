import 'dart:io';
import 'package:rupp_final_mad/domain/repositories/recipe_repository.dart';
import 'package:rupp_final_mad/data/datasources/recipe_remote_datasource.dart';
import 'package:rupp_final_mad/data/models/recipe.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  final RecipeRemoteDataSource _remoteDataSource = RecipeRemoteDataSource();

  @override
  Future<List<Recipe>> getRecipes({int page = 1, int limit = 20, String? cuisine}) async {
    try {
      final response =
          await _remoteDataSource.getRecipes(page: page, limit: limit, cuisine: cuisine);
      return response.payload;
    } catch (e) {
      throw Exception('Failed to get recipes: $e');
    }
  }

  @override
  Future<Recipe> getRecipeById(String id) async {
    try {
      return await _remoteDataSource.getRecipeById(id);
    } catch (e) {
      throw Exception('Failed to get recipe: $e');
    }
  }

  @override
  Future<List<Recipe>> getUserRecipes() async {
    try {
      final response = await _remoteDataSource.getUserRecipes();
      return response.payload;
    } catch (e) {
      throw Exception('Failed to get user recipes: $e');
    }
  }

  @override
  Future<List<Recipe>> getBookmarkedRecipes() async {
    try {
      final response = await _remoteDataSource.getBookmarkedRecipes();
      return response.payload;
    } catch (e) {
      throw Exception('Failed to get bookmarked recipes: $e');
    }
  }

  @override
  Future<Recipe> toggleLike(String id, {Recipe? currentRecipe}) async {
    try {
      return await _remoteDataSource.toggleLike(
        id,
        currentRecipe: currentRecipe,
      );
    } catch (e) {
      throw Exception('Failed to like recipe: $e');
    }
  }

  @override
  Future<Recipe> toggleBookmark(String id, {Recipe? currentRecipe}) async {
    try {
      return await _remoteDataSource.toggleBookmark(
        id,
        currentRecipe: currentRecipe,
      );
    } catch (e) {
      throw Exception('Failed to bookmark recipe: $e');
    }
  }

  @override
  Future<void> deleteRecipe(String id) async {
    try {
      await _remoteDataSource.deleteRecipe(id);
    } catch (e) {
      throw Exception('Failed to delete recipe: $e');
    }
  }

  @override
  Future<Recipe> createRecipe(Map<String, dynamic> data) async {
    try {
      return await _remoteDataSource.createRecipe(data);
    } catch (e) {
      throw Exception('Failed to create recipe: $e');
    }
  }

  @override
  Future<Recipe> updateRecipe(String id, Map<String, dynamic> data) async {
    try {
      return await _remoteDataSource.updateRecipe(id, data);
    } catch (e) {
      throw Exception('Failed to update recipe: $e');
    }
  }

  @override
  Future<List<String>> uploadRecipeImages(
    List<File> imageFiles, {
    String? recipeId,
  }) async {
    try {
      return await _remoteDataSource.uploadRecipeImages(
        imageFiles,
        recipeId: recipeId,
      );
    } catch (e) {
      throw Exception('Failed to upload recipe images: $e');
    }
  }
}
