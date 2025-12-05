import 'package:flutter/material.dart';
import 'package:rupp_final_mad/data/models/recipe.dart';
import 'package:rupp_final_mad/data/repositories/recipe_repository_impl.dart';
import 'package:rupp_final_mad/presentation/widgets/skeleton_loader.dart';

const Color kPrimaryColor = Color(0xFF30A58B);

class RecipeDetailScreen extends StatefulWidget {
  final String recipeId;

  const RecipeDetailScreen({super.key, required this.recipeId});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  final RecipeRepositoryImpl _recipeRepository = RecipeRepositoryImpl();
  Recipe? _recipe;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadRecipe();
  }

  Future<void> _loadRecipe() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final recipe = await _recipeRepository.getRecipeById(widget.recipeId);
      setState(() {
        _recipe = recipe;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load recipe: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 300,
                  pinned: true,
                  flexibleSpace: SkeletonLoader(
                    width: double.infinity,
                    height: 300,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkeletonLoader(width: double.infinity, height: 32),
                        const SizedBox(height: 8),
                        SkeletonLoader(width: 200, height: 20),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            SkeletonLoader(width: 80, height: 16),
                            const SizedBox(width: 24),
                            SkeletonLoader(width: 100, height: 16),
                            const SizedBox(width: 24),
                            SkeletonLoader(width: 60, height: 16),
                          ],
                        ),
                        const SizedBox(height: 32),
                        SkeletonLoader(width: 120, height: 24),
                        const SizedBox(height: 16),
                        ...List.generate(
                            5,
                            (index) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: SkeletonLoader(
                                      width: double.infinity, height: 16),
                                )),
                        const SizedBox(height: 32),
                        SkeletonLoader(width: 120, height: 24),
                        const SizedBox(height: 16),
                        ...List.generate(
                            3,
                            (index) => Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: SkeletonLoader(
                                      width: double.infinity, height: 20),
                                )),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _errorMessage,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => _loadRecipe(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _recipe == null
                  ? const Center(child: Text('Recipe not found'))
                  : CustomScrollView(
                      slivers: [
                        // App Bar with Image
                        SliverAppBar(
                          expandedHeight: 300,
                          pinned: true,
                          flexibleSpace: FlexibleSpaceBar(
                            background: Image.network(
                              _recipe!.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: kPrimaryColor.withOpacity(0.1),
                                  child: const Icon(
                                    Icons.restaurant_menu,
                                    size: 100,
                                    color: kPrimaryColor,
                                  ),
                                );
                              },
                            ),
                          ),
                          leading: IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        // Content
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title
                                Text(
                                  _recipe!.title,
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Description
                                Text(
                                  _recipe!.description,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // Meta Information
                                Row(
                                  children: [
                                    _buildMetaItem(
                                      Icons.access_time,
                                      '${_recipe!.cookingTime} min',
                                    ),
                                    const SizedBox(width: 24),
                                    _buildMetaItem(
                                      Icons.people,
                                      '${_recipe!.servings} servings',
                                    ),
                                    const SizedBox(width: 24),
                                    _buildMetaItem(
                                      Icons.restaurant,
                                      _recipe!.difficulty.toUpperCase(),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                // Stats
                                Row(
                                  children: [
                                    _buildStatItem(
                                      Icons.favorite,
                                      '${_recipe!.likesCount}',
                                      Colors.red,
                                    ),
                                    const SizedBox(width: 24),
                                    _buildStatItem(
                                      Icons.bookmark,
                                      '${_recipe!.bookmarksCount}',
                                      kPrimaryColor,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                // Cuisine
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: kPrimaryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    _recipe!.cuisine,
                                    style: const TextStyle(
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                // Tags
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: _recipe!.tags.map((tag) {
                                    return Chip(
                                      label: Text(tag),
                                      backgroundColor:
                                          kPrimaryColor.withOpacity(0.1),
                                      labelStyle:
                                          const TextStyle(color: kPrimaryColor),
                                    );
                                  }).toList(),
                                ),
                                const SizedBox(height: 32),
                                // Ingredients Section
                                const Text(
                                  'Ingredients',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ..._recipe!.ingredients.map((ingredient) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.check_circle,
                                          color: kPrimaryColor,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            ingredient,
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                                const SizedBox(height: 32),
                                // Instructions Section
                                const Text(
                                  'Instructions',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ..._recipe!.instructions
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                  final index = entry.key + 1;
                                  final instruction = entry.value;
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            color: kPrimaryColor,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Text(
                                              '$index',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            instruction,
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                                const SizedBox(height: 32),
                                // Author Info
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 24,
                                        backgroundImage:
                                            _recipe!.authorPhotoURL.isNotEmpty
                                                ? NetworkImage(
                                                    _recipe!.authorPhotoURL)
                                                : null,
                                        child: _recipe!.authorPhotoURL.isEmpty
                                            ? const Icon(Icons.person)
                                            : null,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Author',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              _recipe!.authorName,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 32),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
    );
  }

  Widget _buildMetaItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade600),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildStatItem(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
        ),
      ],
    );
  }
}
