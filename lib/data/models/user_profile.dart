class UserProfile {
  final int recipesCount;
  final String uid;
  final String updatedAt;
  final String createdAt;
  final String bio;
  final String email;
  final String photoUrl;
  final String displayName;

  UserProfile({
    required this.recipesCount,
    required this.uid,
    required this.updatedAt,
    required this.createdAt,
    required this.bio,
    required this.email,
    required this.photoUrl,
    required this.displayName,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      recipesCount: json['recipes_count'] as int,
      uid: json['uid'] as String,
      updatedAt: json['updated_at'] as String,
      createdAt: json['created_at'] as String,
      bio: json['bio'] as String,
      email: json['email'] as String,
      photoUrl: json['photo_url'] as String? ?? '',
      displayName: json['display_name'] as String,
    );
  }
}

class UserProfileResponse {
  final bool success;
  final String message;
  final UserProfile payload;
  final int status;
  final String timestamp;

  UserProfileResponse({
    required this.success,
    required this.message,
    required this.payload,
    required this.status,
    required this.timestamp,
  });

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
    return UserProfileResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      payload: UserProfile.fromJson(json['payload'] as Map<String, dynamic>),
      status: json['status'] as int,
      timestamp: json['timestamp'] as String,
    );
  }
}
