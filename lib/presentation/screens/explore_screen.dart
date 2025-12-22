import 'package:flutter/material.dart';
import '../widgets/category_card.dart';
import 'recipes_list_screen.dart';

const Color kPrimaryColor = Color(0xFF30A58B);

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  void _navigateToRecipes(BuildContext context, {String? category}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipesListScreen(category: category),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                onPressed: () => _navigateToRecipes(context),
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
              crossAxisCount: 3, // Changed to 3 per row for smaller cards
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.9,
              children: [
                CategoryCard(
                  title: 'Asian',
                  emoji: '🥣',
                  onTap: () => _navigateToRecipes(context, category: 'Asian'),
                ),
                CategoryCard(
                  title: 'Fast food',
                  emoji: '🍔',
                  onTap: () => _navigateToRecipes(context, category: 'Fast food'),
                ),
                CategoryCard(
                  title: 'Dessert',
                  emoji: '🍰',
                  onTap: () => _navigateToRecipes(context, category: 'Dessert'),
                ),
                CategoryCard(
                  title: 'Drink',
                  emoji: '🍹',
                  onTap: () => _navigateToRecipes(context, category: 'Drink'),
                ),
                CategoryCard(
                  title: 'Salad',
                  emoji: '🥗',
                  onTap: () => _navigateToRecipes(context, category: 'Meatless'),
                ),
                CategoryCard(
                  title: 'Soups',
                  emoji: '🍲',
                  onTap: () => _navigateToRecipes(context, category: 'Soups'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
