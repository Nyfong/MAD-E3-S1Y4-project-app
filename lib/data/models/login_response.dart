class LoginResponse {
  final bool success;
  final String message;
  final LoginPayload payload;
  final int status;
  final String timestamp;

  LoginResponse({
    required this.success,
    required this.message,
    required this.payload,
    required this.status,
    required this.timestamp,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      payload: LoginPayload.fromJson(json['payload'] as Map<String, dynamic>),
      status: json['status'] as int,
      timestamp: json['timestamp'] as String,
    );
  }
}

class LoginPayload {
  final String accessToken;
  final String tokenType;
  final User user;

  LoginPayload({
    required this.accessToken,
    required this.tokenType,
    required this.user,
  });

  factory LoginPayload.fromJson(Map<String, dynamic> json) {
    return LoginPayload(
      accessToken: json['access_token'] as String,
      tokenType: json['token_type'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}

class User {
  final int recipesCount;
  final String uid;
  final String updatedAt;
  final String createdAt;
  final String bio;
  final String email;
  final String photoUrl;
  final String displayName;

  User({
    required this.recipesCount,
    required this.uid,
    required this.updatedAt,
    required this.createdAt,
    required this.bio,
    required this.email,
    required this.photoUrl,
    required this.displayName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      recipesCount: json['recipes_count'] as int,
      uid: json['uid'] as String,
      updatedAt: json['updated_at'] as String,
      createdAt: json['created_at'] as String,
      bio: json['bio'] as String,
      email: json['email'] as String,
      photoUrl: json['photo_url'] as String,
      displayName: json['display_name'] as String,
    );
  }
}
