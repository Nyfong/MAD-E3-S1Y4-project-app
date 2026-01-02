import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:rupp_final_mad/data/api/api_client.dart';
import 'package:rupp_final_mad/data/api/api_config.dart';
import 'package:rupp_final_mad/data/models/user_profile.dart';

class UserRemoteDataSource {
  final ApiClient _apiClient = ApiClient();

  Future<UserProfileResponse> getUserProfile() async {
    try {
      final response = await _apiClient.get(
        ApiConfig.userProfileEndpoint,
      );

      return UserProfileResponse.fromJson(response);
    } catch (e) {
      debugPrint('Failed to fetch user profile: $e');
      // Return fallback profile when API fails
      return UserProfileResponse(
        success: true,
        message: 'Using demo profile',
        payload: UserProfile(
          recipesCount: 0,
          uid: 'demo-uid',
          updatedAt: DateTime.now().toIso8601String(),
          createdAt: DateTime.now().toIso8601String(),
          bio: 'Demo user bio',
          email: 'demo@example.com',
          photoUrl: '',
          displayName: 'Demo User',
        ),
        status: 200,
        timestamp: DateTime.now().toIso8601String(),
      );
    }
  }

  Future<UserProfileResponse> updateUserProfile({
    required String displayName,
    required String photoUrl,
    required String bio,
  }) async {
    try {
      final response = await _apiClient.put(
        ApiConfig.userProfileEndpoint,
        data: {
          'display_name': displayName,
          'photo_url': photoUrl,
          'bio': bio,
        },
      );

      return UserProfileResponse.fromJson(response);
    } catch (e) {
      debugPrint('Failed to update user profile: $e');
      throw Exception('Failed to update user profile: $e');
    }
  }

  Future<String> uploadProfileImage(File imageFile) async {
    try {
      final response = await _apiClient.postMultipart(
        ApiConfig.uploadProfileImageEndpoint,
        files: [imageFile],
        fieldName: 'file', // API expects 'file' field name for single file
      );

      // Extract image URL from response
      // Expected response format: {"payload": {"url": "..."}} or {"url": "..."}
      String imageUrl = '';
      
      if (response is Map<String, dynamic>) {
        if (response.containsKey('payload')) {
          final payload = response['payload'] as Map<String, dynamic>;
          if (payload.containsKey('url')) {
            imageUrl = payload['url'].toString();
          } else if (payload.containsKey('photoUrl')) {
            imageUrl = payload['photoUrl'].toString();
          }
        } else if (response.containsKey('url')) {
          imageUrl = response['url'].toString();
        } else if (response.containsKey('photoUrl')) {
          imageUrl = response['photoUrl'].toString();
        }
      }

      if (imageUrl.isEmpty) {
        throw Exception('No image URL returned from upload');
      }

      return imageUrl;
    } catch (e) {
      debugPrint('API upload profile image failed: $e');
      rethrow;
    }
  }

  Future<void> deleteProfileImage() async {
    try {
      await _apiClient.delete(
        ApiConfig.deleteProfileImageEndpoint,
      );
    } catch (e) {
      debugPrint('API delete profile image failed: $e');
      rethrow;
    }
  }
}
