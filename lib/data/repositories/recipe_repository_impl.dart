import 'package:rupp_final_mad/domain/repositories/recipe_repository.dart';
import 'package:rupp_final_mad/data/datasources/recipe_remote_datasource.dart';
import 'package:rupp_final_mad/data/models/recipe.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  final RecipeRemoteDataSource _remoteDataSource = RecipeRemoteDataSource();

  @override
  Future<List<Recipe>> getRecipes({int page = 1, int limit = 20}) async {
    try {
      final response =
          await _remoteDataSource.getRecipes(page: page, limit: limit);
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
}
