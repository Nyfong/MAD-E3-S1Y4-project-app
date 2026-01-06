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
  final String authorBio;
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
    required this.authorBio,
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
      id: json['id'] as String? ?? json['_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      difficulty: json['difficulty'] as String? ?? 'easy',
      cookingTime: (json['cookingTime'] as num?)?.toInt() ?? 
                   (json['cooking_time'] as num?)?.toInt() ?? 0,
      servings: (json['servings'] as num?)?.toInt() ?? 1,
      cuisine: json['cuisine'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? 
                json['image_url'] as String? ?? '',
      authorId: json['authorId'] as String? ?? 
                json['author_id'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 
                  json['author_name'] as String? ?? '',
      authorPhotoURL: json['authorPhotoURL'] as String? ?? 
                      json['author_photo_url'] as String? ?? '',
      authorBio: json['authorBio'] as String? ?? 
                 json['author_bio'] as String? ?? '',
      ingredients: json['ingredients'] != null
          ? (json['ingredients'] as List<dynamic>)
              .map((e) => e.toString())
              .toList()
          : <String>[],
      instructions: json['instructions'] != null
          ? (json['instructions'] as List<dynamic>)
              .map((e) => e.toString())
              .toList()
          : <String>[],
      tags: json['tags'] != null
          ? (json['tags'] as List<dynamic>).map((e) => e.toString()).toList()
          : <String>[],
      likesCount: (json['likesCount'] as num?)?.toInt() ?? 
                  (json['likes_count'] as num?)?.toInt() ?? 0,
      bookmarksCount: (json['bookmarksCount'] as num?)?.toInt() ?? 
                      (json['bookmarks_count'] as num?)?.toInt() ?? 0,
      isLiked: json['isLiked'] as bool? ?? 
               json['is_liked'] as bool? ?? false,
      isBookmarked: json['isBookmarked'] as bool? ?? 
                    json['is_bookmarked'] as bool? ?? false,
      createdAt: json['createdAt'] as String? ?? 
                 json['created_at'] as String? ?? 
                 DateTime.now().toIso8601String(),
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
