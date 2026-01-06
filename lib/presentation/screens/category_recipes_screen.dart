import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rupp_final_mad/data/models/recipe.dart';
import 'package:rupp_final_mad/data/repositories/recipe_repository_impl.dart';
import 'package:rupp_final_mad/presentation/screens/recipe_detail_screen.dart';
import 'package:rupp_final_mad/presentation/widgets/recipe_grid_card.dart';
import 'package:rupp_final_mad/presentation/widgets/recipe_grid_skeleton.dart';

const Color kPrimaryColor = Color(0xFF30A58B);

class CategoryRecipesScreen extends StatefulWidget {
  final String category; // 'minute', 'level', or 'love'
  final String title;

  const CategoryRecipesScreen({
    super.key,
    required this.category,
    required this.title,
  });

  @override
  State<CategoryRecipesScreen> createState() => _CategoryRecipesScreenState();
}

class _CategoryRecipesScreenState extends State<CategoryRecipesScreen> {
  final RecipeRepositoryImpl _recipeRepository = RecipeRepositoryImpl();
  final ScrollController _scrollController = ScrollController();
  List<Recipe> _allRecipes = [];
  List<Recipe> _filteredRecipes = [];
  bool _isLoading = true;
  bool _isLoadingMore = false; // Separate flag for loading more
  String _errorMessage = '';
  int _currentPage = 1;
  final int _limit = 10; // Reduced to 10 for better performance
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadRecipes();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Load more when user scrolls to 90% of the list (near the end)
    if (!_isLoadingMore && 
        _hasMore && 
        _scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      _loadMore();
    }
  }

  List<Recipe> _applyFilter(List<Recipe> recipes) {
    // Filter by cuisine (which stores the category)
    // Categories: dessert, Fast food, Asean, drink, meatless, soup
    // Normalize both strings by removing spaces, hyphens, underscores and converting to lowercase
    final normalizedCategory = widget.category
        .toLowerCase()
        .replaceAll(' ', '')
        .replaceAll('-', '')
        .replaceAll('_', '')
        .trim();
    
    return recipes.where((recipe) {
      if (recipe.cuisine.isEmpty) return false;
      
      final normalizedCuisine = recipe.cuisine
          .toLowerCase()
          .replaceAll(' ', '')
          .replaceAll('-', '')
          .replaceAll('_', '')
          .trim();
      
      // Try exact match first
      if (normalizedCuisine == normalizedCategory) {
        return true;
      }
      
      // Special case for "Fast food" variations - check if both contain "fast" and "food"
      // This handles: "Fast food", "fastfood", "fast-food", "Fast Food", etc.
      if (normalizedCategory.contains('fast') && normalizedCategory.contains('food')) {
        if (normalizedCuisine.contains('fast') && normalizedCuisine.contains('food')) {
          return true;
        }
      }
      
      // Reverse check: if cuisine contains "fast" and "food", and category is "fastfood"
      if (normalizedCuisine.contains('fast') && normalizedCuisine.contains('food')) {
        if (normalizedCategory.contains('fast') && normalizedCategory.contains('food')) {
          return true;
        }
      }
      
      // For other categories, try contains match if both are similar length
      if (normalizedCategory.length >= 3 && normalizedCuisine.length >= 3) {
        if (normalizedCuisine.contains(normalizedCategory) || 
            normalizedCategory.contains(normalizedCuisine)) {
          return true;
        }
      }
      
      return false;
    }).toList();
  }

  Future<void> _loadRecipes({bool loadMore = false}) async {
    if (!loadMore) {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });
    } else {
      setState(() {
        _isLoadingMore = true;
      });
    }

    try {
      // Try API filtering first with the exact category name
      List<Recipe> recipes = await _recipeRepository.getRecipes(
        page: _currentPage,
        limit: _limit,
        cuisine: widget.category, // Pass category to API for server-side filtering
      );

      setState(() {
        if (loadMore) {
          _allRecipes.addAll(recipes);
        } else {
          _allRecipes = recipes;
        }
        // Always apply client-side filter to ensure correct filtering
        // This handles cases where API doesn't filter correctly or returns wrong format
        _filteredRecipes = _applyFilter(_allRecipes);
        
        // If we got recipes from API but filtering resulted in empty list,
        // and this is the first page, try loading all recipes without filter
        if (!loadMore && _filteredRecipes.isEmpty && recipes.isNotEmpty) {
          _loadAllRecipesAndFilter();
          return;
        }
        
        // Only set hasMore if we got the expected number of recipes
        // If filtering reduced the count significantly, we might have more
        _hasMore = recipes.length >= _limit;
        _isLoading = false;
        _isLoadingMore = false;
      });
    } catch (e) {
      // If API call fails completely, try loading all recipes without filter
      if (!loadMore) {
        _loadAllRecipesAndFilter();
      } else {
        setState(() {
          _errorMessage = 'Failed to load recipes: ${e.toString()}';
          _isLoading = false;
          _isLoadingMore = false;
        });
      }
    }
  }

  Future<void> _loadAllRecipesAndFilter() async {
    try {
      debugPrint('Loading all recipes without cuisine filter for client-side filtering');
      // Load all recipes without cuisine filter and filter client-side
      final allRecipes = await _recipeRepository.getRecipes(
        page: 1,
        limit: _limit * 3, // Load more recipes to find matches
      );
      
      setState(() {
        _allRecipes = allRecipes;
        _filteredRecipes = _applyFilter(_allRecipes);
        _hasMore = allRecipes.length >= (_limit * 3);
        _isLoading = false;
        _isLoadingMore = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load recipes: ${e.toString()}';
        _isLoading = false;
        _isLoadingMore = false;
      });
    }
  }

  void _loadMore() {
    if (_hasMore && !_isLoading && !_isLoadingMore) {
      setState(() {
        _currentPage++;
      });
      _loadRecipes(loadMore: true);
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

  int _getCrossAxisCount(double width) {
    return 1;
  }

  double _getChildAspectRatio(double width) {
    if (width > 900) {
      return 0.7;
    } else if (width > 600) {
      return 0.75;
    } else {
      return 0.8;
    }
  }

  IconData _getCategoryIcon() {
    switch (widget.category.toLowerCase()) {
      case 'dessert':
        return Icons.cake_rounded;
      case 'fast food':
        return Icons.fastfood_rounded;
      case 'asean':
        return Icons.restaurant_rounded;
      case 'drink':
        return Icons.local_drink_rounded;
      case 'meatless':
        return Icons.eco_rounded;
      case 'soup':
        return Icons.soup_kitchen_rounded;
      default:
        return Icons.restaurant_menu_rounded;
    }
  }

  String _getCategoryDescription() {
    switch (widget.category.toLowerCase()) {
      case 'dessert':
        return 'Sweet treats and desserts';
      case 'fast food':
        return 'Quick and convenient meals';
      case 'asean':
        return 'Traditional Southeast Asian cuisine';
      case 'drink':
        return 'Refreshing beverages and drinks';
      case 'meatless':
        return 'Vegetarian and plant-based recipes';
      case 'soup':
        return 'Warm and comforting soups';
      default:
        return 'Browse recipes by category';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 72,
        titleSpacing: 16,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getCategoryIcon(),
                color: kPrimaryColor,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              _getCategoryDescription(),
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black54,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final screenWidth = constraints.maxWidth;
                final crossAxisCount = _getCrossAxisCount(screenWidth);
                final childAspectRatio = _getChildAspectRatio(screenWidth);
                final horizontalPadding = screenWidth > 600 ? 16.0 : 12.0;
                final spacing = screenWidth > 600 ? 16.0 : 12.0;

                return _isLoading && _filteredRecipes.isEmpty
                    ? GridView.builder(
                        padding: EdgeInsets.all(horizontalPadding),
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: spacing,
                          mainAxisSpacing: spacing,
                          childAspectRatio: childAspectRatio,
                        ),
                        itemCount: 6,
                        itemBuilder: (context, index) =>
                            const RecipeGridSkeleton(),
                      )
                    : _errorMessage.isNotEmpty &&
                            _filteredRecipes.isEmpty
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 32),
                                    child: Text(
                                      _errorMessage,
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 16,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  SizedBox(
                                    width: double.infinity,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: screenWidth > 600 ? 200 : 32,
                                      ),
                                      child: ElevatedButton(
                                        onPressed: () => _loadRecipes(),
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 16,
                                          ),
                                          backgroundColor: kPrimaryColor,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
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
                        : _filteredRecipes.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      _getCategoryIcon(),
                                      size: 80,
                                      color: kPrimaryColor.withOpacity(0.5),
                                    ),
                                    const SizedBox(height: 24),
                                    const Text(
                                      'No recipes found',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'No recipes in this category yet',
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
                                onRefresh: () async {
                                  setState(() {
                                    _currentPage = 1;
                                    _allRecipes = [];
                                    _filteredRecipes = [];
                                  });
                                  await _loadRecipes();
                                },
                                child: GridView.builder(
                                  controller: _scrollController,
                                  padding: EdgeInsets.all(horizontalPadding),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: crossAxisCount,
                                    crossAxisSpacing: spacing,
                                    mainAxisSpacing: spacing,
                                    childAspectRatio: childAspectRatio,
                                  ),
                                  itemCount: _filteredRecipes.length +
                                      (_hasMore && _isLoadingMore ? 1 : 0),
                                  itemBuilder: (context, index) {
                                    if (index == _filteredRecipes.length) {
                                      return _isLoadingMore
                                          ? const Center(
                                              child: Padding(
                                                padding: EdgeInsets.all(16.0),
                                                child:
                                                    CircularProgressIndicator(
                                                  color: kPrimaryColor,
                                                ),
                                              ),
                                            )
                                          : const SizedBox.shrink();
                                    }

                                    final recipe = _filteredRecipes[index];
                                    return RecipeGridCard(
                                      recipe: recipe,
                                      onTap: () => _navigateToDetail(recipe),
                                    );
                                  },
                                ),
                              );
              },
            ),
          ),
        ],
      ),
    );
  }
}

