// File: lib/widgets/profile_header.dart

import 'package:flutter/material.dart';
import 'package:rupp_final_mad/data/api/api_config.dart';

class ProfileHeader extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String? photoUrl;
  final String? bio;
  final int? recipesCount;
  final VoidCallback? onEditPhoto;

  const ProfileHeader({
    super.key,
    required this.userName,
    required this.userEmail,
    this.photoUrl,
    this.bio,
    this.recipesCount,
    this.onEditPhoto,
  });

  @override
  Widget build(BuildContext context) {
    const Color kPrimaryColor = Color(0xFF30A58B);

    // Resolve full photo URL (handles relative paths from API)
    String? resolvedPhotoUrl;
    if (photoUrl != null && photoUrl!.isNotEmpty) {
      if (photoUrl!.startsWith('http')) {
        resolvedPhotoUrl = photoUrl;
      } else {
        final baseUri = Uri.parse(ApiConfig.baseUrl);
        final hostBase =
            '${baseUri.scheme}://${baseUri.host}${baseUri.hasPort ? ':${baseUri.port}' : ''}';

        if (photoUrl!.startsWith('/')) {
          resolvedPhotoUrl = '$hostBase${photoUrl!}';
        } else {
          resolvedPhotoUrl = '$hostBase/${photoUrl!}';
        }
      }
    }

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [kPrimaryColor, Color(0xFF1E7F68)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar with edit button
          Stack(
            children: [
              CircleAvatar(
                radius: 38,
                backgroundColor: Colors.white.withOpacity(0.12),
                backgroundImage: resolvedPhotoUrl != null
                    ? NetworkImage(resolvedPhotoUrl)
                    : null,
                child: resolvedPhotoUrl == null
                    ? const Icon(
                        Icons.person_rounded,
                        size: 40,
                        color: Colors.white,
                      )
                    : null,
              ),
              if (onEditPhoto != null)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: onEditPhoto,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 18),
          // Name, email, bio and stats
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  userName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  userEmail,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.85),
                  ),
                ),
                if (bio != null && bio!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    bio!,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StatChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.16),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: Colors.white,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
