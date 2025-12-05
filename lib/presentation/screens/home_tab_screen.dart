import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rupp_final_mad/data/models/recipe.dart';
import 'package:rupp_final_mad/data/repositories/recipe_repository_impl.dart';
import 'package:rupp_final_mad/presentation/providers/auth_provider.dart';
import 'package:rupp_final_mad/presentation/screens/recipe_detail_screen.dart';
import 'package:rupp_final_mad/presentation/screens/recipes_list_screen.dart';
import 'package:rupp_final_mad/presentation/widgets/skeleton_loader.dart';

const Color kPrimaryColor = Color(0xFF30A58B);

class HomeTabScreen extends StatefulWidget {
  const HomeTabScreen({super.key});

  @override
  State<HomeTabScreen> createState() => _HomeTabScreenState();
}

class _HomeTabScreenState extends State<HomeTabScreen> {
  final RecipeRepositoryImpl _recipeRepository = RecipeRepositoryImpl();
  List<Recipe> _featuredRecipes = [];
  bool _isLoadingRecipes = true;

  @override
  void initState() {
    super.initState();
    _loadFeaturedRecipes();
  }

  Future<void> _loadFeaturedRecipes() async {
    try {
      final recipes = await _recipeRepository.getRecipes(page: 1, limit: 5);
      setState(() {
        _featuredRecipes = recipes;
        _isLoadingRecipes = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingRecipes = false;
      });
    }
  }

  void _navigateToDetail(Recipe recipe) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeDetailScreen(recipeId: recipe.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get userName from AuthProvider to ensure it updates when profile changes
    final authProvider = Provider.of<AuthProvider>(context);
    final userName = authProvider.userName;
    // Extract first name for a friendlier greeting
    final userFirstName = userName.split(' ').first;

    return Scaffold(
      // 2. Add the custom AppBar
      appBar: AppBar(
        automaticallyImplyLeading:
            false, // Prevents a back button from appearing
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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RecipesListScreen(),
                          ),
                        );
                      },
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
              child: _isLoadingRecipes
                  ? ListView.builder(
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
                            width: 160,
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SkeletonLoader(
                                  width: double.infinity,
                                  height: 120,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                const SizedBox(height: 8),
                                SkeletonLoader(
                                    width: double.infinity, height: 16),
                                const SizedBox(height: 4),
                                SkeletonLoader(width: 100, height: 12),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : _featuredRecipes.isEmpty
                      ? const Center(
                          child: Text('No recipes available'),
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _featuredRecipes.length,
                          itemBuilder: (context, index) {
                            final recipe = _featuredRecipes[index];
                            return InkWell(
                              onTap: () => _navigateToDetail(recipe),
                              child: Card(
                                margin: const EdgeInsets.only(right: 16),
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Container(
                                  width: 160, // Slightly wider card
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          recipe.imageUrl,
                                          height: 120,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Container(
                                              height: 120,
                                              decoration: BoxDecoration(
                                                color: kPrimaryColor
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: const Center(
                                                child: Icon(
                                                  Icons.restaurant_menu_rounded,
                                                  size: 50,
                                                  color: kPrimaryColor,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        recipe.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        recipe.description,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
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
