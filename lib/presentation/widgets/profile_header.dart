// File: lib/widgets/profile_header.dart

import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String? photoUrl;
  final String? bio;
  final int? recipesCount;

  const ProfileHeader({
    super.key,
    required this.userName,
    required this.userEmail,
    this.photoUrl,
    this.bio,
    this.recipesCount,
  });

  @override
  Widget build(BuildContext context) {
    // Branded color for the avatar background
    const Color kPrimaryColor = Color(0xFF30A58B);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Branded Avatar
            CircleAvatar(
              radius: 50,
              backgroundColor: kPrimaryColor.withOpacity(0.1),
              backgroundImage: photoUrl != null && photoUrl!.isNotEmpty
                  ? NetworkImage(photoUrl!)
                  : null,
              child: photoUrl == null || photoUrl!.isEmpty
                  ? const Icon(
                      Icons.person_rounded,
                      size: 50,
                      color: kPrimaryColor,
                    )
                  : null,
            ),
            const SizedBox(height: 16),

            // User Name
            Text(
              userName,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),

            // User Email
            Text(
              userEmail,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),

            // Bio (if available)
            if (bio != null && bio!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                bio!,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ],

            // Recipes Count (if available)
            if (recipesCount != null) ...[
              const SizedBox(height: 16),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.restaurant_menu,
                      size: 18,
                      color: kPrimaryColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$recipesCount Recipes',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: kPrimaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
