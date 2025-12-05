import 'package:rupp_final_mad/data/models/recipe.dart';

abstract class RecipeRepository {
  Future<List<Recipe>> getRecipes({int page = 1, int limit = 20});
  Future<Recipe> getRecipeById(String id);
  Future<List<Recipe>> getUserRecipes();
}
