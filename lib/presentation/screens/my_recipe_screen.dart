import 'package:flutter/material.dart';
import 'package:rupp_final_mad/data/models/recipe.dart';
import 'package:rupp_final_mad/data/repositories/recipe_repository_impl.dart';
import 'package:rupp_final_mad/presentation/screens/recipe_detail_screen.dart';
import 'package:rupp_final_mad/presentation/widgets/skeleton_loader.dart';

// Color definitions (Reusing the brand colors)
const Color kPrimaryColor = Color(0xFF30A58B); // Teal/Sea Green

class MyRecipeScreen extends StatefulWidget {
  const MyRecipeScreen({super.key});

  @override
  State<MyRecipeScreen> createState() => _MyRecipeScreenState();
}

class _MyRecipeScreenState extends State<MyRecipeScreen> {
  final RecipeRepositoryImpl _recipeRepository = RecipeRepositoryImpl();
  final TextEditingController _searchController = TextEditingController();
  List<Recipe> _recipes = [];
  List<Recipe> _favoriteRecipes = [];
  bool _isLoading = true;
  String _errorMessage = '';
  bool _showFavorites = false; // Toggle between My Recipes and Favorites
  String _searchQuery = ''; // Search query for filtering recipes

  @override
  void initState() {
    super.initState();
    _loadUserRecipes();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  // Filter recipes based on search query
  List<Recipe> _getFilteredRecipes() {
    final recipesToFilter = _showFavorites ? _favoriteRecipes : _recipes;
    if (_searchQuery.isEmpty) {
      return recipesToFilter;
    }
    return recipesToFilter
        .where((recipe) => recipe.title.toLowerCase().contains(_searchQuery))
        .toList();
  }

  Future<void> _loadUserRecipes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final recipes = await _recipeRepository.getUserRecipes();
      setState(() {
        _recipes = recipes;
        _favoriteRecipes = recipes.where((r) => r.isBookmarked).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load recipes: ${e.toString()}';
        _isLoading = false;
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
      body: Column(
        children: [
          // 0. Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search recipes by name...',
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
          ),
          // 1. Action Buttons Row
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 12.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final screenWidth = constraints.maxWidth;
                final isSmallScreen = screenWidth < 600;

                if (isSmallScreen) {
                  // Stack buttons vertically on small screens
                  return Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Action to navigate to the Add Recipe screen
                          },
                          icon: const Icon(Icons.add_circle_outline, size: 22),
                          label: const Text(
                            'Add New Recipe',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                            shadowColor: kPrimaryColor.withOpacity(0.4),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            setState(() {
                              _showFavorites = !_showFavorites;
                            });
                          },
                          icon: Icon(
                            _showFavorites
                                ? Icons.restaurant_menu
                                : Icons.favorite,
                            size: 22,
                          ),
                          label: Text(
                            _showFavorites ? 'My Recipes' : 'My Favorites',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: _showFavorites
                                  ? kPrimaryColor
                                  : Colors.red.shade400,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _showFavorites
                                ? kPrimaryColor
                                : Colors.red.shade400,
                            side: BorderSide(
                              color: _showFavorites
                                  ? kPrimaryColor
                                  : Colors.red.shade400,
                              width: 2,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  // Side by side on larger screens
                  return Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Action to navigate to the Add Recipe screen
                          },
                          icon: const Icon(Icons.add_circle_outline, size: 22),
                          label: const Text(
                            'Add New Recipe',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                            shadowColor: kPrimaryColor.withOpacity(0.4),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            setState(() {
                              _showFavorites = !_showFavorites;
                            });
                          },
                          icon: Icon(
                            _showFavorites
                                ? Icons.restaurant_menu
                                : Icons.favorite,
                            size: 22,
                          ),
                          label: Text(
                            _showFavorites ? 'My Recipes' : 'My Favorites',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: _showFavorites
                                  ? kPrimaryColor
                                  : Colors.red.shade400,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _showFavorites
                                ? kPrimaryColor
                                : Colors.red.shade400,
                            side: BorderSide(
                              color: _showFavorites
                                  ? kPrimaryColor
                                  : Colors.red.shade400,
                              width: 2,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),

          // 2. Recipe List
          Expanded(
            child: _isLoading
                ? ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                    itemCount: 5,
                    itemBuilder: (context, index) =>
                        const RecipeListItemSkeleton(),
                  )
                : _errorMessage.isNotEmpty
                    ? Center(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 80,
                                color: Colors.red.withOpacity(0.5),
                              ),
                              const SizedBox(height: 24),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 32),
                                child: Text(
                                  _errorMessage,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.red,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width > 600
                                            ? 200
                                            : 32,
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () => _loadUserRecipes(),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      backgroundColor: kPrimaryColor,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text(
                                      'Retry',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : _getFilteredRecipes().isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  _searchQuery.isNotEmpty
                                      ? Icons.search_off
                                      : (_showFavorites
                                          ? Icons.favorite_border
                                          : Icons.restaurant_menu),
                                  size: 80,
                                  color: kPrimaryColor.withOpacity(0.5),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  _searchQuery.isNotEmpty
                                      ? 'No recipes found'
                                      : (_showFavorites
                                          ? 'No favorite recipes yet'
                                          : 'No recipes yet'),
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _searchQuery.isNotEmpty
                                      ? 'Try searching with a different name'
                                      : (_showFavorites
                                          ? 'Start bookmarking recipes to see them here!'
                                          : "Tap 'Add New Recipe' above to get started!"),
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: () => _loadUserRecipes(),
                            child: ListView.builder(
                              padding: const EdgeInsets.fromLTRB(
                                  16.0, 0, 16.0, 16.0),
                              itemCount: _getFilteredRecipes().length,
                              itemBuilder: (context, index) {
                                final recipe = _getFilteredRecipes()[index];
                                return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  elevation: 3,
                                  margin: const EdgeInsets.only(bottom: 16),
                                  child: InkWell(
                                    onTap: () => _navigateToDetail(recipe),
                                    borderRadius: BorderRadius.circular(15),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        children: [
                                          // Recipe Image
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.network(
                                              recipe.imageUrl,
                                              width: 60,
                                              height: 60,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Container(
                                                  width: 60,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    color: kPrimaryColor
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Icon(
                                                    Icons
                                                        .restaurant_menu_rounded,
                                                    color: kPrimaryColor,
                                                    size: 30,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          // Recipe Info
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  recipe.title,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  recipe.description,
                                                  style: TextStyle(
                                                    color: Colors.grey.shade600,
                                                    fontSize: 14,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 4),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.access_time,
                                                      size: 14,
                                                      color:
                                                          Colors.grey.shade600,
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      '${recipe.cookingTime} min',
                                                      style: TextStyle(
                                                        color: Colors
                                                            .grey.shade600,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 12),
                                                    Icon(
                                                      Icons.favorite,
                                                      size: 14,
                                                      color:
                                                          Colors.red.shade300,
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      '${recipe.likesCount}',
                                                      style: TextStyle(
                                                        color: Colors
                                                            .grey.shade600,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Icon(
                                            Icons.chevron_right_rounded,
                                            size: 24,
                                            color: Colors.grey.shade400,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }
}
