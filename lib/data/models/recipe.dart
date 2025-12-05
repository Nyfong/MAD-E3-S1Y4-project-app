class Recipe {
  final String id;
  final String title;
  final String description;
  final String difficulty;
  final int cookingTime;
  final int servings;
  final String cuisine;
  final String imageUrl;
  final String authorId;
  final String authorName;
  final String authorPhotoURL;
  final List<String> ingredients;
  final List<String> instructions;
  final List<String> tags;
  final int likesCount;
  final int bookmarksCount;
  final bool isLiked;
  final bool isBookmarked;
  final String createdAt;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.cookingTime,
    required this.servings,
    required this.cuisine,
    required this.imageUrl,
    required this.authorId,
    required this.authorName,
    required this.authorPhotoURL,
    required this.ingredients,
    required this.instructions,
    required this.tags,
    required this.likesCount,
    required this.bookmarksCount,
    required this.isLiked,
    required this.isBookmarked,
    required this.createdAt,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      difficulty: json['difficulty'] as String,
      cookingTime: json['cookingTime'] as int,
      servings: json['servings'] as int,
      cuisine: json['cuisine'] as String,
      imageUrl: json['imageUrl'] as String,
      authorId: json['authorId'] as String,
      authorName: json['authorName'] as String,
      authorPhotoURL: json['authorPhotoURL'] as String? ?? '',
      ingredients: (json['ingredients'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      instructions: (json['instructions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      likesCount: json['likesCount'] as int,
      bookmarksCount: json['bookmarksCount'] as int,
      isLiked: json['isLiked'] as bool? ?? false,
      isBookmarked: json['isBookmarked'] as bool? ?? false,
      createdAt: json['createdAt'] as String,
    );
  }
}

class RecipesResponse {
  final bool success;
  final String message;
  final List<Recipe> payload;
  final int status;
  final String timestamp;

  RecipesResponse({
    required this.success,
    required this.message,
    required this.payload,
    required this.status,
    required this.timestamp,
  });

  factory RecipesResponse.fromJson(Map<String, dynamic> json) {
    return RecipesResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      payload: (json['payload'] as List<dynamic>)
          .map((e) => Recipe.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status'] as int,
      timestamp: json['timestamp'] as String,
    );
  }
}
