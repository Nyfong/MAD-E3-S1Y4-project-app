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
    switch (widget.category) {
      case 'minute':
        // Show recipes with cooking time <= 30 minutes (quick recipes)
        return recipes.where((recipe) => recipe.cookingTime <= 30).toList();
      case 'level':
        // Show recipes grouped by difficulty level
        // Sort by difficulty: Easy, Medium, Hard
        final sorted = List<Recipe>.from(recipes);
        sorted.sort((a, b) {
          final order = {'Easy': 1, 'Medium': 2, 'Hard': 3, 'easy': 1, 'medium': 2, 'hard': 3};
          final aOrder = order[a.difficulty.toLowerCase()] ?? 4;
          final bOrder = order[b.difficulty.toLowerCase()] ?? 4;
          return aOrder.compareTo(bOrder);
        });
        return sorted;
      case 'love':
        // Show only recipes with likesCount > 0 (recipes that have been liked)
        return recipes.where((recipe) => recipe.likesCount > 0).toList();
      default:
        return recipes;
    }
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
      final recipes = await _recipeRepository.getRecipes(
        page: _currentPage,
        limit: _limit,
      );

      setState(() {
        if (loadMore) {
          _allRecipes.addAll(recipes);
        } else {
          _allRecipes = recipes;
        }
        _filteredRecipes = _applyFilter(_allRecipes);
        _hasMore = recipes.length == _limit;
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
    switch (widget.category) {
      case 'minute':
        return Icons.timer_rounded;
      case 'level':
        return Icons.trending_up_rounded;
      case 'love':
        return Icons.favorite_rounded;
      default:
        return Icons.restaurant_menu_rounded;
    }
  }

  String _getCategoryDescription() {
    switch (widget.category) {
      case 'minute':
        return 'Quick recipes ready in 30 minutes or less';
      case 'level':
        return 'Recipes organized by difficulty level';
      case 'love':
        return 'Popular recipes with likes from the community';
      default:
        return 'Browse recipes';
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
                                      widget.category == 'love'
                                          ? Icons.favorite_border_rounded
                                          : Icons.search_off,
                                      size: 80,
                                      color: kPrimaryColor.withOpacity(0.5),
                                    ),
                                    const SizedBox(height: 24),
                                    Text(
                                      widget.category == 'love'
                                          ? 'No popular recipes yet'
                                          : 'No recipes found',
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      widget.category == 'love'
                                          ? 'Recipes with likes will appear here'
                                          : 'Try again later',
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

