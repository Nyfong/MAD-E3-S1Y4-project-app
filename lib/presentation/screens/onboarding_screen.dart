// File: lib/presentation/screens/onboarding_screen.dart

import 'package:flutter/material.dart';
import 'package:rupp_final_mad/presentation/screens/login_screen.dart';
import 'package:rupp_final_mad/data/services/onboarding_service.dart';
// Import the new widget created for the content
// NOTE: We will only pass the page data to this widget now,
// and handle buttons in the parent screen.
import 'package:rupp_final_mad/presentation/widgets/onboarding_page_content.dart';

// Define the Dark Mint color (Needed here for indicator)
const Color kDarkMintColor = Color(0xFF1AA788);

// --- Onboarding Page Data Model (Unchanged) ---
class OnboardingPage {
  final String imagePath;
  final String title;
  final String description;

  OnboardingPage({
    required this.imagePath,
    required this.title,
    required this.description,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // --- Data Model and Pages (Unchanged) ---
  final List<OnboardingPage> _pages = [
    OnboardingPage(
      imagePath: 'assets/images/image1.png',
      title: 'Discover the Latest Trends ',
      description: 'Stay ahead of the curve. Find curated content that matches your unique style and interests every day.',
    ),
    OnboardingPage(
      imagePath: 'assets/images/image2.png',
      title: 'Connect with Your Tribe ',
      description: 'Join communities and chat with people who share your passion. Real connections, no filters.',
    ),
    OnboardingPage(
      imagePath: 'assets/images/image3.png',
      title: 'Level Up Your Skills ',
      description: 'Access quick, engaging lessons on everything from coding to cooking. Learn on the go, anytime.',
    ),
    OnboardingPage(
      imagePath: 'assets/images/image4.png',
      title: 'Ready to Dive In? ',
      description: 'Unleash your potential and start creating. All the tools you need are right here, right now.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // --- Navigation Logic (Unchanged) ---

  Future<void> _completeOnboarding() async {
    await OnboardingService.completeOnboarding();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  // --- Widget Builders (Moved from OnboardingPageContent) ---

  // Action Button for NEXT/GET STARTED
  Widget _buildActionButton({required String text, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: kDarkMintColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 6,
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  // Skip Button
  Widget _buildSkipButton() {
    // Hidden on the last page
    if (_currentPage == _pages.length - 1) return const SizedBox.shrink();

    return Align(
      alignment: Alignment.topRight,
      child: TextButton(
        onPressed: _skipOnboarding, // Navigates to main app route
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        ),
        child: Text(
          'SKIP',
          style: TextStyle(
            fontSize: 17,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  // Page Indicator (Dots)
  Widget _buildPageIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: isActive ? 24 : 10,
      height: 10,
      decoration: BoxDecoration(
        color: isActive ? kDarkMintColor : Colors.grey.shade400,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  // --- UI Build Method (Main Logic Change) ---

  @override
  Widget build(BuildContext context) {
    // We use Stack to layer the static elements (buttons, dots) over the sliding PageView
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // 1. Sliding Content (PageView) - Fills the entire space
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: _pages.length,
              itemBuilder: (context, index) {
                // The content widget now only needs the page data.
                // It should NOT contain the Skip button, dots, or action button.
                return OnboardingPageContent(
                  page: _pages[index],
                  // Pass the page and context, but strip out the buttons/indicators
                  isLastPage: index == _pages.length - 1, // Still useful for content logic
                  // Placeholder/unused: The buttons are now controlled by the parent screen
                  onNextPressed: _nextPage,
                  onSkipPressed: _skipOnboarding,
                  currentPageIndex: index,
                  totalPages: _pages.length,
                );
              },
            ),

            // 2. Static Overlay (Buttons and Indicators)

            // A. Skip Button (Top Right)
            _buildSkipButton(),

            // B. Bottom Controls (Dots and Action Button)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 0, 30.0, 30.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Wrap content height
                  children: [
                    // Dots (Page Indicators)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _pages.length,
                            (index) => _buildPageIndicator(index == _currentPage),
                      ),
                    ),
                    const SizedBox(height: 50), // Spacing between dots and button

                    // Action Button (NEXT or GET STARTED)
                    SizedBox(
                      height: 60,
                      width: double.infinity,
                      child: _currentPage == _pages.length - 1
                          ? _buildActionButton(text: 'GET STARTED', onPressed: _nextPage)
                          : _buildActionButton(text: 'NEXT', onPressed: _nextPage),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
