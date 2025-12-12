import 'package:flutter/material.dart';

// Color definitions (Reusing the brand colors)
const Color kPrimaryColor = Color(0xFF30A58B); // Teal/Sea Green

class MyRecipeScreen extends StatelessWidget {
  const MyRecipeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // NOTE: If this screen is used with a BottomNavigationBar, using a leading icon
    // in the AppBar might conflict. I'll use a spacious AppBar similar to the ExploreScreen.
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Recipes',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900, // Heavy weight for title
            color: kPrimaryColor, // Branded color
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 80,
        centerTitle: false,
        titleSpacing: 16.0,
      ),
      // The main action button (Add Recipe) will be moved to the body's column
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0), // Padding adjusted
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch children for button
          children: [
            // 1. Updated 'Add Recipe' Button
            ElevatedButton.icon(
              onPressed: () {
                // Action to navigate to the Add Recipe screen
              },
              icon: const Icon(Icons.add_circle_outline, size: 24),
              label: const Text(
                'Add New Recipe',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor, // Branded color background
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15), // Consistent large radius
                ),
                elevation: 6, // Elevated effect
                shadowColor: kPrimaryColor.withOpacity(0.5),
              ),
            ),

            const SizedBox(height: 32),

            // 2. Recipe List
            // NOTE: I'm temporarily using 3 items to show the list style,
            // but the conditional empty state check below is better for production.
            if (false) // Set to 'false' to show the example list items
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 3, // Displaying sample items for styling demo
                itemBuilder: (context, index) {
                  return Card(
                    // Consistent large rounded corners
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 3, // Subtle elevation
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: kPrimaryColor.withOpacity(0.1), // Light branded color background
                          borderRadius: BorderRadius.circular(10), // Slightly smaller radius than the card
                        ),
                        child: Icon(Icons.restaurant_menu_rounded, color: kPrimaryColor, size: 30),
                      ),
                      title: const Text(
                        'Spicy Peanut Noodles',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Quick and easy vegetarian dinner.',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      trailing: Icon(
                        Icons.chevron_right_rounded, // Better visual than arrow_forward_ios
                        size: 24,
                        color: Colors.grey.shade400,
                      ),
                      onTap: () {},
                    ),
                  );
                },
              ),

            // 3. Empty State UI (If the ListView.builder above has itemCount: 0)
            if (true) // Replace with actual check for empty recipes
              Center(
                child: Column(
                  children: [
                    const SizedBox(height: 80),
                    // Branded icon for empty state
                    Icon(
                      Icons.restaurant_menu,
                      size: 80, // Larger size
                      color: kPrimaryColor.withOpacity(0.5), // Subtle branded color
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'No recipes yet',
                      style: TextStyle(
                        fontSize: 22, // Larger text
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Tap 'Add New Recipe' above to get started!",
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}