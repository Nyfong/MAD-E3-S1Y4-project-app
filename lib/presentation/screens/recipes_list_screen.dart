import 'package:flutter/material.dart';
import 'package:rupp_final_mad/data/models/recipe.dart';
import 'package:rupp_final_mad/data/repositories/recipe_repository_impl.dart';
import 'package:rupp_final_mad/presentation/screens/recipe_detail_screen.dart';
import 'package:rupp_final_mad/presentation/widgets/recipe_grid_card.dart';
import 'package:rupp_final_mad/presentation/widgets/recipe_grid_skeleton.dart';

const Color kPrimaryColor = Color(0xFF30A58B);

class RecipesListScreen extends StatefulWidget {
  const RecipesListScreen({super.key});

  @override
  State<RecipesListScreen> createState() => _RecipesListScreenState();
}

class _RecipesListScreenState extends State<RecipesListScreen> {
  final RecipeRepositoryImpl _recipeRepository = RecipeRepositoryImpl();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  List<Recipe> _recipes = [];
  bool _isLoading = true;
  String _errorMessage = '';
  int _currentPage = 1;
  final int _limit = 20;
  bool _hasMore = true;
  String _searchQuery = ''; // Search query for filtering recipes

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadRecipes();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _searchController.removeListener(_onSearchChanged);
    _scrollController.dispose();
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
    if (_searchQuery.isEmpty) {
      return _recipes;
    }
    return _recipes
        .where((recipe) => recipe.title.toLowerCase().contains(_searchQuery))
        .toList();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      _loadMore();
    }
  }

  Future<void> _loadRecipes({bool loadMore = false}) async {
    if (!loadMore) {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });
    }

    try {
      final recipes = await _recipeRepository.getRecipes(
        page: _currentPage,
        limit: _limit,
      );

      setState(() {
        if (loadMore) {
          _recipes.addAll(recipes);
        } else {
          _recipes = recipes;
        }
        _hasMore = recipes.length == _limit;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load recipes: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  void _loadMore() {
    if (_hasMore && !_isLoading) {
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

  // Responsive grid configuration
  int _getCrossAxisCount(double width) {
    if (width > 900) {
      return 3; // Large screens: 3 columns
    } else if (width > 600) {
      return 2; // Medium screens: 2 columns
    } else {
      return 2; // Small screens: 2 columns
    }
  }

  double _getChildAspectRatio(double width) {
    if (width > 900) {
      return 0.75; // Slightly taller for 3 columns
    } else if (width > 600) {
      return 0.72; // Medium aspect ratio
    } else {
      return 0.7; // Standard for 2 columns
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Recipes',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: kPrimaryColor,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 80,
      ),
      body: Column(
        children: [
          // Search Bar
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
          // Recipe Grid
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final screenWidth = constraints.maxWidth;
                final crossAxisCount = _getCrossAxisCount(screenWidth);
                final childAspectRatio = _getChildAspectRatio(screenWidth);

                // Responsive padding
                final horizontalPadding = screenWidth > 600 ? 16.0 : 12.0;
                final spacing = screenWidth > 600 ? 16.0 : 12.0;

                return _isLoading && _recipes.isEmpty
                    ? GridView.builder(
                        padding: EdgeInsets.all(horizontalPadding),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: spacing,
                          mainAxisSpacing: spacing,
                          childAspectRatio: childAspectRatio,
                        ),
                        itemCount: 6,
                        itemBuilder: (context, index) =>
                            const RecipeGridSkeleton(),
                      )
                    : _errorMessage.isNotEmpty && _recipes.isEmpty
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
                                        horizontal:
                                            screenWidth > 600 ? 200 : 32,
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
                        : _getFilteredRecipes().isEmpty &&
                                _searchQuery.isNotEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.search_off,
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
                                      'Try searching with a different name',
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
                                    _recipes = [];
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
                                  itemCount: _getFilteredRecipes().length +
                                      (_hasMore && _searchQuery.isEmpty
                                          ? 1
                                          : 0),
                                  itemBuilder: (context, index) {
                                    if (index == _getFilteredRecipes().length) {
                                      return _hasMore
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

                                    final recipe = _getFilteredRecipes()[index];
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
