// File: lib/widgets/profile_header.dart

import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String userName;
  final String userEmail;

  const ProfileHeader({
    super.key,
    required this.userName,
    required this.userEmail,
  });

  @override
  Widget build(BuildContext context) {
    // Branded color for the avatar background
    const Color kPrimaryColor = Color(0xFF30A58B);

    return Column(
      children: [
        // Branded Avatar
        CircleAvatar(
          radius: 50,
          backgroundColor: kPrimaryColor.withOpacity(0.1),
          child: const Icon(
            Icons.person_rounded, // Slightly updated icon
            size: 50,
            color: kPrimaryColor,
          ),
        ),
        const SizedBox(height: 16),

        // User Name
        Text(
          userName,
          style: const TextStyle(
            fontSize: 26, // Slightly larger
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
      ],
    );
  }
}