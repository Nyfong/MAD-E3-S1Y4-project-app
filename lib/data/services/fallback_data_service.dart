import 'package:rupp_final_mad/data/models/recipe.dart';

class FallbackDataService {
  static List<Recipe> getFallbackRecipes() {
    return [
      Recipe(
        id: 'fallback-1',
        title: 'Classic Spaghetti Carbonara',
        description:
            'A traditional Italian pasta dish with eggs, cheese, and bacon.',
        difficulty: 'medium',
        cookingTime: 20,
        servings: 4,
        cuisine: 'Italian',
        imageUrl: 'https://via.placeholder.com/150',
        authorId: 'demo-author',
        authorName: 'Demo Chef',
        authorPhotoURL: '',
        ingredients: ['spaghetti', 'eggs', 'parmesan', 'bacon', 'black pepper'],
        instructions: [
          'Cook spaghetti according to package directions',
          'Fry bacon until crispy',
          'Mix eggs and parmesan in a bowl',
          'Combine everything and serve hot'
        ],
        tags: ['pasta', 'italian', 'dinner'],
        likesCount: 15,
        bookmarksCount: 8,
        isLiked: false,
        isBookmarked: false,
        createdAt: DateTime.now().toIso8601String(),
      ),
      Recipe(
        id: 'fallback-2',
        title: 'Chocolate Chip Cookies',
        description: 'Soft and chewy homemade chocolate chip cookies.',
        difficulty: 'easy',
        cookingTime: 15,
        servings: 24,
        cuisine: 'American',
        imageUrl: 'https://via.placeholder.com/150',
        authorId: 'demo-author',
        authorName: 'Demo Chef',
        authorPhotoURL: '',
        ingredients: ['flour', 'butter', 'sugar', 'chocolate chips', 'vanilla'],
        instructions: [
          'Mix dry ingredients',
          'Cream butter and sugar',
          'Combine and add chocolate chips',
          'Bake at 375°F for 10-12 minutes'
        ],
        tags: ['dessert', 'baking', 'sweet'],
        likesCount: 23,
        bookmarksCount: 12,
        isLiked: false,
        isBookmarked: false,
        createdAt: DateTime.now().toIso8601String(),
      ),
      Recipe(
        id: 'fallback-3',
        title: 'Grilled Chicken Salad',
        description: 'Healthy and refreshing salad with grilled chicken.',
        difficulty: 'easy',
        cookingTime: 25,
        servings: 2,
        cuisine: 'Mediterranean',
        imageUrl: 'https://via.placeholder.com/150',
        authorId: 'demo-author',
        authorName: 'Demo Chef',
        authorPhotoURL: '',
        ingredients: [
          'chicken breast',
          'lettuce',
          'tomatoes',
          'cucumber',
          'olive oil'
        ],
        instructions: [
          'Grill chicken until cooked through',
          'Chop vegetables',
          'Mix salad ingredients',
          'Dress with olive oil and serve'
        ],
        tags: ['healthy', 'salad', 'lunch'],
        likesCount: 18,
        bookmarksCount: 10,
        isLiked: false,
        isBookmarked: false,
        createdAt: DateTime.now().toIso8601String(),
      ),
    ];
  }

  static Recipe getFallbackRecipe(String id) {
    return getFallbackRecipes().firstWhere(
      (recipe) => recipe.id == id,
      orElse: () => getFallbackRecipes().first,
    );
  }
}
