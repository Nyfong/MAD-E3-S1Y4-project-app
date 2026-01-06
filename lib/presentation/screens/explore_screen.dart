import 'package:flutter/material.dart';
import '../widgets/category_card.dart';
import 'recipes_list_screen.dart';
import 'category_recipes_screen.dart';

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

            // Modern View All Recipes Button
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [kPrimaryColor, kPrimaryColor.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: kPrimaryColor.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RecipesListScreen(),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.restaurant_menu_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'View All Recipes',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ],
                    ),
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

            // Grid of category cards - 6 categories
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.25,
              children: [
                CategoryCard(
                  title: 'Dessert',
                  icon: Icons.cake_rounded,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CategoryRecipesScreen(
                          category: 'dessert',
                          title: 'Dessert',
                        ),
                      ),
                    );
                  },
                ),
                CategoryCard(
                  title: 'Fast Food',
                  icon: Icons.fastfood_rounded,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CategoryRecipesScreen(
                          category: 'Fast food',
                          title: 'Fast Food',
                        ),
                      ),
                    );
                  },
                ),
                CategoryCard(
                  title: 'Asean',
                  icon: Icons.restaurant_rounded,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CategoryRecipesScreen(
                          category: 'Asean',
                          title: 'Asean',
                        ),
                      ),
                    );
                  },
                ),
                CategoryCard(
                  title: 'Drink',
                  icon: Icons.local_drink_rounded,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CategoryRecipesScreen(
                          category: 'drink',
                          title: 'Drink',
                        ),
                      ),
                    );
                  },
                ),
                CategoryCard(
                  title: 'Meatless',
                  icon: Icons.eco_rounded,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CategoryRecipesScreen(
                          category: 'meatless',
                          title: 'Meatless',
                        ),
                      ),
                    );
                  },
                ),
                CategoryCard(
                  title: 'Soup',
                  icon: Icons.soup_kitchen_rounded,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CategoryRecipesScreen(
                          category: 'soup',
                          title: 'Soup',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
