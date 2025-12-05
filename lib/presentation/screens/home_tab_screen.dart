
import 'package:flutter/material.dart';

const Color kPrimaryColor = Color(0xFF30A58B);

class HomeTabScreen extends StatelessWidget {
  final String userName;

  const HomeTabScreen({
    super.key,
    required this.userName, // Now requires userName
  });

  @override
  Widget build(BuildContext context) {
    // Extract first name for a friendlier greeting
    final userFirstName = userName.split(' ').first;

    return Scaffold(
      // 2. Add the custom AppBar
      appBar: AppBar(
        automaticallyImplyLeading: false, // Prevents a back button from appearing
        toolbarHeight: 80, // Taller AppBar for better design
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Greeting Text
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, $userFirstName!', // Use dynamic name
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'What would you like to cook today?',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),

            // Avatar
            CircleAvatar(
              radius: 24,
              backgroundColor: kPrimaryColor.withOpacity(0.15),
              child: const Icon(
                Icons.person_rounded,
                color: kPrimaryColor, // Teal icon color
                size: 28,
              ),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // NOTE: Removed the redundant 'Welcome to Recipe App' text since it's now in the AppBar

            // Design Update: Card using kPrimaryColor
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Discover Amazing Recipes',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Explore a world of delicious recipes and create your own culinary masterpieces.',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor, // Teal background
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Get Started'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Featured Recipes',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 16),

            // Featured Recipe List
            SizedBox(
              height: 220, // Increased height to fit larger cards
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.only(right: 16),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      width: 160, // Slightly wider card
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 120, // Taller image container
                            decoration: BoxDecoration(
                              color: kPrimaryColor.withOpacity(0.1), // Light teal background
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.restaurant_menu_rounded,
                                size: 50,
                                color: kPrimaryColor, // Teal icon
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Recipe ${index + 1}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const Text(
                            'Delicious dish',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}