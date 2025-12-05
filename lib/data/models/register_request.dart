class RegisterRequest {
  final String email;
  final String displayName;
  final String photoUrl;
  final String bio;
  final String password;

  RegisterRequest({
    required this.email,
    required this.displayName,
    required this.photoUrl,
    required this.bio,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'display_name': displayName,
      'photo_url': photoUrl,
      'bio': bio,
      'password': password,
    };
  }
}
