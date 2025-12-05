// File: lib/screens/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Assuming these imports are correct based on your setup
import '../providers/auth_provider.dart';
import 'login_screen.dart';

// Import the custom widgets
import '../widgets/profile_header.dart';
import '../widgets/profile_action_card.dart';

// Color definitions (Ensure this is imported or defined in your theme file)
const Color kPrimaryColor = Color(0xFF30A58B);
 // A nice red for Logout

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),

            // 1. User Header (Reusable Widget)
            ProfileHeader(
              userName: userName,
              userEmail: userEmail,
            ),

            const SizedBox(height: 32),

            // 2. Action Card (Reusable Widget)
            const ProfileActionCard(),

            const SizedBox(height: 24),

            // 3. Logout Button (Styled for consistency)
            ElevatedButton.icon(
              onPressed: () {
                // Logout Logic
                authProvider.logout();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.logout),
              label: const Text(
                'Logout',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor, // Red Logout color
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15), // Consistent radius
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