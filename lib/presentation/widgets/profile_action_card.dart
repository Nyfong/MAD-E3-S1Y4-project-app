// File: lib/widgets/profile_action_card.dart

import 'package:flutter/material.dart';
import 'package:rupp_final_mad/presentation/screens/edit_profile_screen.dart';
import 'package:rupp_final_mad/data/models/user_profile.dart';

class ProfileActionCard extends StatelessWidget {
  final UserProfile? userProfile;
  final VoidCallback? onProfileUpdated;

  const ProfileActionCard({
    super.key,
    this.userProfile,
    this.onProfileUpdated,
  });

  @override
  Widget build(BuildContext context) {
    const Color kPrimaryColor = Color(0xFF30A58B);

    // Helper to create a single styled ListTile
    Widget _buildActionItem({
      required IconData icon,
      required String title,
      required VoidCallback onTap,
    }) {
      return ListTile(
        leading: Icon(icon, color: kPrimaryColor), // Branded icon color
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        trailing: Icon(
          Icons.chevron_right_rounded, // Modern arrow icon
          size: 24,
          color: Colors.grey.shade400,
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      );
    }

    return Card(
      // Consistent large rounded corners
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4, // Subtle elevation
      shadowColor: Colors.black.withOpacity(0.1),
      child: Column(
        children: [
          _buildActionItem(
            icon: Icons.person_outline_rounded,
            title: 'Edit Profile',
            onTap: () async {
              if (userProfile != null) {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfileScreen(
                      userProfile: userProfile!,
                    ),
                  ),
                );
                // If profile was updated, refresh the profile screen
                if (result == true && onProfileUpdated != null) {
                  onProfileUpdated!();
                }
              }
            },
          ),
          const Divider(height: 1, indent: 20, endIndent: 20),
          _buildActionItem(
            icon: Icons.settings_outlined,
            title: 'Settings',
            onTap: () {},
          ),
          const Divider(height: 1, indent: 20, endIndent: 20),
          _buildActionItem(
            icon: Icons.help_outline_rounded,
            title: 'Help & Support',
            onTap: () {},
          ),
          const Divider(height: 1, indent: 20, endIndent: 20),
          _buildActionItem(
            icon: Icons.info_outline_rounded,
            title: 'About',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
