import 'package:flutter/material.dart';
// Assuming the OnboardingPage model is in onboarding_screen.dart
import 'package:rupp_final_mad/presentation/screens/onboarding_screen.dart';

// The Dark Mint color is no longer strictly needed here, but kept for context.
// const Color kDarkMintColor = Color(0xFF1AA788);

class OnboardingPageContent extends StatelessWidget {
  final OnboardingPage page;
  final bool isLastPage;
  // These callbacks and properties are no longer used by this widget,
  // but we keep them to prevent breaking the parent OnboardingScreen's build
  // until it is also updated to only pass required data.
  final VoidCallback onNextPressed;
  final VoidCallback onSkipPressed;
  final int totalPages;
  final int currentPageIndex;

  const OnboardingPageContent({
    super.key,
    required this.page,
    required this.isLastPage,
    required this.onNextPressed,
    required this.onSkipPressed,
    required this.totalPages,
    required this.currentPageIndex,
  });

  // --- Main Build Method ---

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Adjusted top padding for better visual spacing now that the Skip button is removed
      padding: const EdgeInsets.fromLTRB(30.0, 50.0, 30.0, 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. Skip Button: REMOVED from here. It is now handled by the parent screen.

          // 2. Image Section
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Image.asset(
                page.imagePath,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // 3. Content Section (Title, Description)
          Column(
            children: [
              // Page Indicators (Dots): REMOVED from here. Now handled by the parent screen.

              // Spacing adjustment to account for removed dots
              const SizedBox(height: 10),

              // Title
              Text(
                page.title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 18),

              // Description
              Text(
                page.description,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),

          // 4. Spacer to push content up
          const Spacer(),

          // 5. Fixed Vertical Space: This space ensures the sliding content doesn't
          // overlap with the fixed buttons/dots placed at the bottom of the parent screen.
          const SizedBox(height: 150),

          // Action Button: REMOVED from here. Now handled by the parent screen.
        ],
      ),
    );
  }
}