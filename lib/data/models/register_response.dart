class RegisterResponse {
  final bool success;
  final String message;
  final RegisterPayload payload;
  final int status;
  final String timestamp;

  RegisterResponse({
    required this.success,
    required this.message,
    required this.payload,
    required this.status,
    required this.timestamp,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      payload:
          RegisterPayload.fromJson(json['payload'] as Map<String, dynamic>),
      status: json['status'] as int,
      timestamp: json['timestamp'] as String,
    );
  }
}

class RegisterPayload {
  final String email;
  final String displayName;
  final String photoUrl;
  final String bio;
  final String passwordHash;
  final String uid;
  final String createdAt;
  final String updatedAt;
  final int recipesCount;

  RegisterPayload({
    required this.email,
    required this.displayName,
    required this.photoUrl,
    required this.bio,
    required this.passwordHash,
    required this.uid,
    required this.createdAt,
    required this.updatedAt,
    required this.recipesCount,
  });

  factory RegisterPayload.fromJson(Map<String, dynamic> json) {
    return RegisterPayload(
      email: json['email'] as String,
      displayName: json['display_name'] as String,
      photoUrl: json['photo_url'] as String,
      bio: json['bio'] as String,
      passwordHash: json['password_hash'] as String,
      uid: json['uid'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      recipesCount: json['recipes_count'] as int,
    );
  }
}
