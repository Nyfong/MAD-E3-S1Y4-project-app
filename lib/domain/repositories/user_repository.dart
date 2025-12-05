import 'package:rupp_final_mad/data/models/user_profile.dart';

abstract class UserRepository {
  Future<UserProfile> getUserProfile();
  Future<UserProfile> updateUserProfile({
    required String displayName,
    required String photoUrl,
    required String bio,
  });
}
