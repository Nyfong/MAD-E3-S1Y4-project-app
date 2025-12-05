// File: lib/screens/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rupp_final_mad/data/models/user_profile.dart';
import 'package:rupp_final_mad/data/repositories/user_repository_impl.dart';
import 'package:rupp_final_mad/presentation/widgets/skeleton_loader.dart';

// Assuming these imports are correct based on your setup
import '../providers/auth_provider.dart';
import 'login_screen.dart';

// Import the custom widgets
import '../widgets/profile_header.dart';
import '../widgets/profile_action_card.dart';

// Color definitions (Ensure this is imported or defined in your theme file)
const Color kPrimaryColor = Color(0xFF30A58B);
// A nice red for Logout

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserRepositoryImpl _userRepository = UserRepositoryImpl();
  UserProfile? _userProfile;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final profile = await _userRepository.getUserProfile();
      setState(() {
        _userProfile = profile;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load profile: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Note: This dependency on Provider/Auth logic remains in the screen file,
    // as it manages the screen's behavior and data.
    final authProvider = Provider.of<AuthProvider>(context);
    final userName = authProvider.userName;
    final userEmail = authProvider.userEmail;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: kPrimaryColor,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 80,
        centerTitle: false,
        titleSpacing: 16.0,
      ),
      body: _isLoading
          ? SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  // Skeleton for Profile Header
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          SkeletonLoader(
                            width: 80,
                            height: 80,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SkeletonLoader(width: 150, height: 20),
                                const SizedBox(height: 8),
                                SkeletonLoader(width: 200, height: 16),
                                const SizedBox(height: 8),
                                SkeletonLoader(width: 100, height: 14),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Skeleton for Action Card
                  const ProfileActionCard(),
                  const SizedBox(height: 24),
                  // Skeleton for Logout Button
                  SkeletonLoader(
                    width: double.infinity,
                    height: 56,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ],
              ),
            )
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 80,
                        color: Colors.red.withOpacity(0.5),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        _errorMessage,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => _loadUserProfile(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 16),

                      // 1. User Header (Reusable Widget)
                      ProfileHeader(
                        userName: _userProfile?.displayName ?? userName,
                        userEmail: _userProfile?.email ?? userEmail,
                        photoUrl: _userProfile?.photoUrl,
                        bio: _userProfile?.bio,
                        recipesCount: _userProfile?.recipesCount,
                      ),

                      const SizedBox(height: 32),

                      // 2. Action Card (Reusable Widget)
                      ProfileActionCard(
                        userProfile: _userProfile,
                        onProfileUpdated: () async {
                          await _loadUserProfile();
                          // Also refresh auth provider to update cached user name
                          if (mounted) {
                            final authProvider = Provider.of<AuthProvider>(
                                context,
                                listen: false);
                            await authProvider.refreshUserProfile();
                          }
                        },
                      ),

                      const SizedBox(height: 24),

                      // 3. Logout Button (Styled for consistency)
                      ElevatedButton.icon(
                        onPressed: () async {
                          // Logout Logic
                          await authProvider.logout();
                          if (context.mounted) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.logout),
                        label: const Text(
                          'Logout',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor, // Red Logout color
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(15), // Consistent radius
                          ),
                          elevation: 6,
                          shadowColor: kPrimaryColor.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
