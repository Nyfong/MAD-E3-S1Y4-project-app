import 'package:flutter/material.dart';
import '../widgets/category_card.dart';
import 'recipes_list_screen.dart';

const Color kPrimaryColor = Color(0xFF30A58B);

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Page title
        title: const Text(
          'Explore Recipes',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: kPrimaryColor,
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 80,
        titleSpacing: 16,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search recipes...',
                prefixIcon:
                    Icon(Icons.search, color: kPrimaryColor.withOpacity(0.7)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: kPrimaryColor, width: 2),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
              ),
            ),
            const SizedBox(height: 24),

            // View All Recipes Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RecipesListScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'View All Recipes',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Section title
            const Text(
              'Categories',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Grid of category cards
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.25,
              children: const [
                CategoryCard(title: 'Breakfast', icon: Icons.breakfast_dining),
                CategoryCard(title: 'Lunch', icon: Icons.lunch_dining),
                CategoryCard(title: 'Dinner', icon: Icons.dinner_dining),
                CategoryCard(title: 'Dessert', icon: Icons.cake),
                CategoryCard(title: 'Snacks', icon: Icons.cookie),
                CategoryCard(title: 'Beverages', icon: Icons.local_cafe),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
