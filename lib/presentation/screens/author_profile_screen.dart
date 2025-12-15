import 'package:flutter/material.dart';
import 'package:rupp_final_mad/data/api/api_config.dart';
import 'package:rupp_final_mad/data/models/recipe.dart';
import 'package:rupp_final_mad/data/repositories/recipe_repository_impl.dart';
import 'package:rupp_final_mad/presentation/screens/recipe_detail_screen.dart';
import 'package:rupp_final_mad/presentation/widgets/profile_header.dart';

class AuthorProfileScreen extends StatefulWidget {
  final String authorId;
  final String authorName;
  final String authorPhotoUrl;
  final String? authorBio;

  const AuthorProfileScreen({
    super.key,
    required this.authorId,
    required this.authorName,
    required this.authorPhotoUrl,
    this.authorBio,
  });

  @override
  State<AuthorProfileScreen> createState() => _AuthorProfileScreenState();
}

class _AuthorProfileScreenState extends State<AuthorProfileScreen> {
  final RecipeRepositoryImpl _recipeRepository = RecipeRepositoryImpl();
  final List<Recipe> _recipes = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadAuthorRecipes();
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

  Future<void> _loadAuthorRecipes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Load first page with a larger limit and filter by author id
      final recipes = await _recipeRepository.getRecipes(page: 1, limit: 100);
      final authorRecipes =
          recipes.where((r) => r.authorId == widget.authorId).toList();

      if (!mounted) return;
      setState(() {
        _recipes
          ..clear()
          ..addAll(authorRecipes);
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage =
            'Failed to load recipes for this author: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Author Profile'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadAuthorRecipes,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            ProfileHeader(
              userName: widget.authorName,
              userEmail: '',
              photoUrl: widget.authorPhotoUrl,
              bio: (widget.authorBio != null && widget.authorBio!.isNotEmpty)
                  ? widget.authorBio
                  : null,
              recipesCount: _recipes.isNotEmpty ? _recipes.length : null,
            ),
            const SizedBox(height: 12),
            Text(
              'Author ID: ${widget.authorId}',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Recipes by this author',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Text(
                    _errorMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              )
            else if (_recipes.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Text(
                    'No recipes found for this author.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else ...[
              const SizedBox(height: 4),
              ..._recipes.map(_buildRecipeCard),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeCard(Recipe recipe) {
    final imageUrl = _resolveImageUrl(recipe.imageUrl) ?? recipe.imageUrl;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecipeDetailScreen(
                  recipeId: recipe.id,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 8,
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          width: 64,
                          height: 64,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 64,
                          height: 64,
                          color: Colors.grey.withOpacity(0.15),
                          child: const Icon(
                            Icons.restaurant_menu,
                            color: Colors.grey,
                          ),
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipe.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        recipe.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${recipe.cookingTime} min',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.restaurant,
                            size: 14,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            recipe.difficulty.toUpperCase(),
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
