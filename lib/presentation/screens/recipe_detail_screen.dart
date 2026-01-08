import 'package:flutter/material.dart';
import 'package:rupp_final_mad/data/api/api_config.dart';
import 'package:rupp_final_mad/data/models/recipe.dart';
import 'package:rupp_final_mad/data/repositories/recipe_repository_impl.dart';
import 'package:rupp_final_mad/presentation/screens/author_profile_screen.dart';
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
  bool _isLiking = false;
  bool _isBookmarking = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadRecipe();
  }

  String? _resolveImageUrl(String? url) {
    if (url == null || url.isEmpty) return null;
    if (url.startsWith('http')) return url;

    final baseUri = Uri.parse(ApiConfig.baseUrl);
    final hostBase =
        '${baseUri.scheme}://${baseUri.host}${baseUri.hasPort ? ':${baseUri.port}' : ''}';

    if (url.startsWith('/')) {
      return '$hostBase$url';
    } else {
      return '$hostBase/$url';
    }
  }

  Widget _buildRecipeImage() {
    if (_recipe == null) {
      return Container(
        color: kPrimaryColor.withOpacity(0.1),
        child: const Icon(
          Icons.restaurant_menu,
          size: 100,
          color: kPrimaryColor,
        ),
      );
    }
    
    final imageUrl = _resolveImageUrl(_recipe!.imageUrl) ?? _recipe!.imageUrl;
    if (imageUrl.isEmpty || imageUrl == 'string') {
      return Container(
        color: kPrimaryColor.withOpacity(0.1),
        child: const Icon(
          Icons.restaurant_menu,
          size: 100,
          color: kPrimaryColor,
        ),
      );
    }
    
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: kPrimaryColor.withOpacity(0.1),
          child: Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
              color: kPrimaryColor,
              strokeWidth: 2,
            ),
          ),
        );
      },
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
    );
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

  Future<void> _toggleLike() async {
    if (_recipe == null || _isLiking) return;

    // Store the current recipe as a backup
    final currentRecipe = _recipe!;

    setState(() {
      _isLiking = true;
    });

    try {
      final updatedRecipe = await _recipeRepository.toggleLike(
        currentRecipe.id,
        currentRecipe: currentRecipe,
      );
      if (!mounted) return;
      
      // Always ensure we have a valid recipe - never set to null
      if (updatedRecipe != null && updatedRecipe.id.isNotEmpty) {
        setState(() {
          _recipe = updatedRecipe;
          _isLiking = false;
        });
      } else {
        // If updated recipe is invalid, keep the current recipe but update the like status optimistically
        setState(() {
          _recipe = Recipe(
            id: currentRecipe.id,
            title: currentRecipe.title,
            description: currentRecipe.description,
            difficulty: currentRecipe.difficulty,
            cookingTime: currentRecipe.cookingTime,
            servings: currentRecipe.servings,
            cuisine: currentRecipe.cuisine,
            imageUrl: currentRecipe.imageUrl,
            authorId: currentRecipe.authorId,
            authorName: currentRecipe.authorName,
            authorPhotoURL: currentRecipe.authorPhotoURL,
            authorBio: currentRecipe.authorBio,
            ingredients: currentRecipe.ingredients,
            instructions: currentRecipe.instructions,
            tags: currentRecipe.tags,
            likesCount: currentRecipe.likesCount + (currentRecipe.isLiked ? -1 : 1),
            bookmarksCount: currentRecipe.bookmarksCount,
            isLiked: !currentRecipe.isLiked,
            isBookmarked: currentRecipe.isBookmarked,
            createdAt: currentRecipe.createdAt,
          );
          _isLiking = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to like recipe: ${e.toString()}')),
      );
      // On error, update optimistically to keep UI consistent
      setState(() {
        _recipe = Recipe(
          id: currentRecipe.id,
          title: currentRecipe.title,
          description: currentRecipe.description,
          difficulty: currentRecipe.difficulty,
          cookingTime: currentRecipe.cookingTime,
          servings: currentRecipe.servings,
          cuisine: currentRecipe.cuisine,
          imageUrl: currentRecipe.imageUrl,
          authorId: currentRecipe.authorId,
          authorName: currentRecipe.authorName,
          authorPhotoURL: currentRecipe.authorPhotoURL,
          authorBio: currentRecipe.authorBio,
          ingredients: currentRecipe.ingredients,
          instructions: currentRecipe.instructions,
          tags: currentRecipe.tags,
          likesCount: currentRecipe.likesCount + (currentRecipe.isLiked ? -1 : 1),
          bookmarksCount: currentRecipe.bookmarksCount,
          isLiked: !currentRecipe.isLiked,
          isBookmarked: currentRecipe.isBookmarked,
          createdAt: currentRecipe.createdAt,
        );
        _isLiking = false;
      });
    }
  }

  Future<void> _toggleBookmark() async {
    if (_recipe == null || _isBookmarking) return;

    // Store the current recipe as a backup
    final currentRecipe = _recipe!;

    setState(() {
      _isBookmarking = true;
    });

    try {
      final updatedRecipe = await _recipeRepository.toggleBookmark(
        currentRecipe.id,
        currentRecipe: currentRecipe,
      );
      if (!mounted) return;
      
      // Always ensure we have a valid recipe - never set to null
      if (updatedRecipe != null && updatedRecipe.id.isNotEmpty) {
        setState(() {
          _recipe = updatedRecipe;
          _isBookmarking = false;
        });
      } else {
        // If updated recipe is invalid, keep the current recipe but update the bookmark status optimistically
        setState(() {
          _recipe = Recipe(
            id: currentRecipe.id,
            title: currentRecipe.title,
            description: currentRecipe.description,
            difficulty: currentRecipe.difficulty,
            cookingTime: currentRecipe.cookingTime,
            servings: currentRecipe.servings,
            cuisine: currentRecipe.cuisine,
            imageUrl: currentRecipe.imageUrl,
            authorId: currentRecipe.authorId,
            authorName: currentRecipe.authorName,
            authorPhotoURL: currentRecipe.authorPhotoURL,
            authorBio: currentRecipe.authorBio,
            ingredients: currentRecipe.ingredients,
            instructions: currentRecipe.instructions,
            tags: currentRecipe.tags,
            likesCount: currentRecipe.likesCount,
            bookmarksCount: currentRecipe.bookmarksCount + (currentRecipe.isBookmarked ? -1 : 1),
            isLiked: currentRecipe.isLiked,
            isBookmarked: !currentRecipe.isBookmarked,
            createdAt: currentRecipe.createdAt,
          );
          _isBookmarking = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to bookmark recipe: ${e.toString()}')),
      );
      // On error, update optimistically to keep UI consistent
      setState(() {
        _recipe = Recipe(
          id: currentRecipe.id,
          title: currentRecipe.title,
          description: currentRecipe.description,
          difficulty: currentRecipe.difficulty,
          cookingTime: currentRecipe.cookingTime,
          servings: currentRecipe.servings,
          cuisine: currentRecipe.cuisine,
          imageUrl: currentRecipe.imageUrl,
          authorId: currentRecipe.authorId,
          authorName: currentRecipe.authorName,
          authorPhotoURL: currentRecipe.authorPhotoURL,
          authorBio: currentRecipe.authorBio,
          ingredients: currentRecipe.ingredients,
          instructions: currentRecipe.instructions,
          tags: currentRecipe.tags,
          likesCount: currentRecipe.likesCount,
          bookmarksCount: currentRecipe.bookmarksCount + (currentRecipe.isBookmarked ? -1 : 1),
          isLiked: currentRecipe.isLiked,
          isBookmarked: !currentRecipe.isBookmarked,
          createdAt: currentRecipe.createdAt,
        );
        _isBookmarking = false;
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
                          actions: [
                            IconButton(
                              onPressed: _isLiking ? null : () => _toggleLike(),
                              icon: _isLiking
                                  ? const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation(
                                            Colors.white),
                                      ),
                                    )
                                  : Icon(
                                      _recipe?.isLiked ?? false
                                          ? Icons.thumb_up
                                          : Icons.thumb_up_outlined,
                                    ),
                              color: Colors.blue,
                              tooltip: 'Like',
                            ),
                          ],
                          flexibleSpace: FlexibleSpaceBar(
                            background: _buildRecipeImage(),
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
                                    GestureDetector(
                                      onTap: _isLiking ? null : () {
                                        _toggleLike();
                                      },
                                      behavior: HitTestBehavior.opaque,
                                      child: InkWell(
                                        onTap: null,
                                        borderRadius: BorderRadius.circular(8),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 4,
                                            vertical: 4,
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                _recipe!.isLiked
                                                    ? Icons.thumb_up
                                                    : Icons.thumb_up_outlined,
                                                size: 20,
                                                color: Colors.blue,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                '${_recipe!.likesCount}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey.shade700,
                                                ),
                                              ),
                                              if (_isLiking) ...[
                                                const SizedBox(width: 6),
                                                const SizedBox(
                                                  width: 12,
                                                  height: 12,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 24),
                                    GestureDetector(
                                      onTap: _isBookmarking ? null : () {
                                        _toggleBookmark();
                                      },
                                      behavior: HitTestBehavior.opaque,
                                      child: InkWell(
                                        onTap: null,
                                        borderRadius: BorderRadius.circular(8),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 4,
                                            vertical: 4,
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                _recipe!.isBookmarked
                                                    ? Icons.bookmark
                                                    : Icons.bookmark_border,
                                                size: 20,
                                                color: kPrimaryColor,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                '${_recipe!.bookmarksCount}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey.shade700,
                                                ),
                                              ),
                                              if (_isBookmarking) ...[
                                                const SizedBox(width: 6),
                                                const SizedBox(
                                                  width: 12,
                                                  height: 12,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                      ),
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
                                InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: () {
                                    final resolvedPhoto = _resolveImageUrl(
                                            _recipe!.authorPhotoURL) ??
                                        _recipe!.authorPhotoURL;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AuthorProfileScreen(
                                          authorId: _recipe!.authorId,
                                          authorName: _recipe!.authorName,
                                          authorPhotoUrl: resolvedPhoto,
                                          authorBio: _recipe!.authorBio,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 24,
                                          backgroundImage: _recipe!
                                                  .authorPhotoURL.isNotEmpty
                                              ? NetworkImage(_resolveImageUrl(
                                                      _recipe!
                                                          .authorPhotoURL) ??
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
