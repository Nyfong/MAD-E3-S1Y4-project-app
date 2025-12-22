import 'package:flutter/material.dart';
import 'package:rupp_final_mad/data/models/recipe.dart';
import 'package:rupp_final_mad/data/repositories/recipe_repository_impl.dart';
import 'package:rupp_final_mad/presentation/screens/recipe_detail_screen.dart';
import 'package:rupp_final_mad/presentation/widgets/recipe_grid_card.dart';
import 'package:rupp_final_mad/presentation/widgets/recipe_grid_skeleton.dart';

const Color kPrimaryColor = Color(0xFF30A58B);

class RecipesListScreen extends StatefulWidget {
  final String? category;
  const RecipesListScreen({super.key, this.category});

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
  String _searchQuery = ''; 

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

  List<Recipe> _getFilteredRecipes() {
    List<Recipe> filtered = _recipes;
    
    // Filter by category if provided
    if (widget.category != null && widget.category!.isNotEmpty) {
      filtered = filtered.where((recipe) => 
        recipe.tags.any((tag) => tag.toLowerCase() == widget.category!.toLowerCase()) ||
        recipe.cuisine.toLowerCase() == widget.category!.toLowerCase()
      ).toList();
    }

    if (_searchQuery.isEmpty) {
      return filtered;
    }
    return filtered
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

  int _getCrossAxisCount(double width) {
    return 2; // Two cards per line as requested
  }

  double _getChildAspectRatio(double width) {
    // Square-ish aspect ratio for the cards in 2-column layout
    return 0.85; 
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.category ?? 'All Recipes';
    
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 72,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.restaurant_menu,
                color: kPrimaryColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search in $title...',
                  prefixIcon: const Icon(Icons.search, color: kPrimaryColor),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 20),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged();
                        },
                      )
                    : null,
                ),
              ),
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final screenWidth = constraints.maxWidth;
                final crossAxisCount = _getCrossAxisCount(screenWidth);
                final childAspectRatio = _getChildAspectRatio(screenWidth);
                const spacing = 12.0;
                const horizontalPadding = 16.0;

                final filteredRecipes = _getFilteredRecipes();

                return _isLoading && _recipes.isEmpty
                    ? GridView.builder(
                        padding: const EdgeInsets.all(horizontalPadding),
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
                            child: Padding(
                              padding: const EdgeInsets.all(32),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.error_outline, size: 60, color: Colors.red.withOpacity(0.5)),
                                  const SizedBox(height: 16),
                                  Text(_errorMessage, textAlign: TextAlign.center),
                                  TextButton(onPressed: () => _loadRecipes(), child: const Text('Retry')),
                                ],
                              ),
                            ),
                          )
                        : filteredRecipes.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.search_off, size: 80, color: kPrimaryColor.withOpacity(0.3)),
                                    const SizedBox(height: 16),
                                    const Text('No recipes found', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                                  padding: const EdgeInsets.all(horizontalPadding),
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: crossAxisCount,
                                    crossAxisSpacing: spacing,
                                    mainAxisSpacing: spacing,
                                    childAspectRatio: childAspectRatio,
                                  ),
                                  itemCount: filteredRecipes.length + (_hasMore && _searchQuery.isEmpty ? 1 : 0),
                                  itemBuilder: (context, index) {
                                    if (index == filteredRecipes.length) {
                                      return const Center(child: Padding(padding: EdgeInsets.all(16.0), child: CircularProgressIndicator(color: kPrimaryColor)));
                                    }

                                    final recipe = filteredRecipes[index];
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
