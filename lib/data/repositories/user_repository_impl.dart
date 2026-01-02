import 'dart:io';
import 'package:rupp_final_mad/domain/repositories/user_repository.dart';
import 'package:rupp_final_mad/data/datasources/user_remote_datasource.dart';
import 'package:rupp_final_mad/data/models/user_profile.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource _remoteDataSource = UserRemoteDataSource();

  @override
  Future<UserProfile> getUserProfile() async {
    try {
      final response = await _remoteDataSource.getUserProfile();
      return response.payload;
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  @override
  Future<UserProfile> updateUserProfile({
    required String displayName,
    required String photoUrl,
    required String bio,
  }) async {
    try {
      final response = await _remoteDataSource.updateUserProfile(
        displayName: displayName,
        photoUrl: photoUrl,
        bio: bio,
      );
      return response.payload;
    } catch (e) {
      throw Exception('Failed to update user profile: $e');
    }
  }

  @override
  Future<String> uploadProfileImage(File imageFile) async {
    try {
      return await _remoteDataSource.uploadProfileImage(imageFile);
    } catch (e) {
      throw Exception('Failed to upload profile image: $e');
    }
  }

  @override
  Future<void> deleteProfileImage() async {
    try {
      await _remoteDataSource.deleteProfileImage();
    } catch (e) {
      throw Exception('Failed to delete profile image: $e');
    }
  }
}
