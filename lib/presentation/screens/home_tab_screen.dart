import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:rupp_final_mad/data/models/recipe.dart';
import 'package:rupp_final_mad/data/repositories/recipe_repository_impl.dart';
import 'package:rupp_final_mad/presentation/providers/auth_provider.dart';
import 'package:rupp_final_mad/presentation/screens/recipe_detail_screen.dart';
import 'package:rupp_final_mad/presentation/screens/recipes_list_screen.dart';
import 'package:rupp_final_mad/presentation/widgets/skeleton_loader.dart';
import 'package:rupp_final_mad/data/api/api_config.dart';

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

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  String _resolveImageUrl(String url) {
    if (url.isEmpty || url == 'string' || url.trim().isEmpty) return '';
    
    // If it's already a full URL (http or https), return it as-is
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return url.trim();
    }

    // Otherwise, prepend the base URL
    final baseUri = Uri.parse(ApiConfig.baseUrl);
    final hostBase =
        '${baseUri.scheme}://${baseUri.host}${baseUri.hasPort ? ':${baseUri.port}' : ''}';

    final trimmedUrl = url.trim();
    if (trimmedUrl.startsWith('/')) {
      return '$hostBase$trimmedUrl';
    } else {
      return '$hostBase/$trimmedUrl';
    }
  }

  Future<void> _loadFeaturedRecipes() async {
    try {
      final recipes = await _recipeRepository.getRecipes(page: 1, limit: 10);
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

  Widget _buildMostFavoriteList(List<Recipe> mostFavorite) {
    if (_isLoadingRecipes || mostFavorite.isEmpty) {
      return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _isLoadingRecipes ? 3 : 1,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(right: 16),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: Container(
              width: 190,
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonLoader(
                    width: double.infinity,
                    height: 110,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  const SizedBox(height: 8),
                  SkeletonLoader(
                      width: double.infinity, height: 16),
                  const SizedBox(height: 4),
                  SkeletonLoader(width: 80, height: 12),
                ],
              ),
            ),
          );
        },
      );
    }

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: mostFavorite.length.clamp(0, 5),
      itemBuilder: (context, index) {
        final recipe = mostFavorite[index];
        return Padding(
          padding: const EdgeInsets.only(right: 16),
          child: GestureDetector(
            onTap: () => _navigateToDetail(recipe),
            child: Container(
              width: 190,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 14,
                    offset: const Offset(0, 7),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: () {
                        final imageUrl = _resolveImageUrl(recipe.imageUrl);
                        if (imageUrl.isEmpty || imageUrl == 'string') {
                          return Container(
                            color: kPrimaryColor.withOpacity(0.08),
                            child: Icon(
                              Icons.thumb_up,
                              color: kPrimaryColor.withOpacity(0.7),
                              size: 40,
                            ),
                          );
                        }
                        return Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          headers: const {'Accept': 'image/*'},
                          cacheWidth: 400,
                          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                            if (wasSynchronouslyLoaded) return child;
                            return AnimatedOpacity(
                              opacity: frame == null ? 0 : 1,
                              duration: const Duration(milliseconds: 200),
                              child: child,
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              color: kPrimaryColor.withOpacity(0.08),
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
                            if (kDebugMode) {
                              debugPrint('Home screen favorite image error: $error');
                              debugPrint('Image URL: $imageUrl');
                            }
                            return Container(
                              color: kPrimaryColor.withOpacity(0.08),
                              child: Icon(
                                Icons.thumb_up,
                                color: kPrimaryColor.withOpacity(0.7),
                                size: 40,
                              ),
                            );
                          },
                        );
                      }(),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.05),
                              Colors.black.withOpacity(0.65),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              recipe.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(
                                  Icons.thumb_up,
                                  size: 14,
                                  color: Colors.blue,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${recipe.likesCount}',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Icon(
                                  Icons.access_time,
                                  size: 14,
                                  color: Colors.white70,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${recipe.cookingTime} min',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get userName from AuthProvider to ensure it updates when profile changes
    final authProvider = Provider.of<AuthProvider>(context);
    final userName = authProvider.userName;
    // Extract first name for a friendlier greeting
    final userFirstName = userName.split(' ').first;

    // Derive a "most favorite" list sorted by likes (descending)
    final List<Recipe> mostFavorite = List.of(_featuredRecipes)
      ..sort((a, b) => (b.likesCount).compareTo(a.likesCount));

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, $userFirstName',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Find your next favorite dish',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            CircleAvatar(
              radius: 24,
              backgroundColor: kPrimaryColor.withOpacity(0.15),
              child: const Icon(
                Icons.person_rounded,
                color: kPrimaryColor,
                size: 28,
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadFeaturedRecipes,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      kPrimaryColor,
                      kPrimaryColor.withOpacity(0.8),
                    ],
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
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getGreeting(),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Welcome back, $userFirstName! 👋',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Ready to cook something amazing today?',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.wb_sunny_rounded,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 12),
                    const Icon(Icons.search, color: kPrimaryColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: 'Search recipes, cuisines, ingredients...',
                          border: InputBorder.none,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RecipesListScreen(),
                            ),
                          );
                        },
                        readOnly: true,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.tune, color: kPrimaryColor),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RecipesListScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Featured recipes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 220,
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
                              width: 170,
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
                              return Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: GestureDetector(
                                  onTap: () => _navigateToDetail(recipe),
                                  child: Container(
                                    width: 190,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(18),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.06),
                                          blurRadius: 12,
                                          offset: const Offset(0, 6),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(18),
                                      child: Stack(
                                        children: [
                                          Positioned.fill(
                                            child: () {
                                              final imageUrl =
                                                  _resolveImageUrl(recipe.imageUrl);
                                              if (imageUrl.isEmpty ||
                                                  imageUrl == 'string') {
                                                return Container(
                                                  color: kPrimaryColor.withOpacity(0.08),
                                                  child: Icon(
                                                    Icons.restaurant_menu_rounded,
                                                    color: kPrimaryColor.withOpacity(0.6),
                                                    size: 40,
                                                  ),
                                                );
                                              }
                                              return Image.network(
                                                imageUrl,
                                                fit: BoxFit.cover,
                                                headers: const {'Accept': 'image/*'},
                                                cacheWidth: 400,
                                                frameBuilder: (context, child, frame,
                                                    wasSynchronouslyLoaded) {
                                                  if (wasSynchronouslyLoaded) {
                                                    return child;
                                                  }
                                                  return AnimatedOpacity(
                                                    opacity: frame == null ? 0 : 1,
                                                    duration:
                                                        const Duration(milliseconds: 200),
                                                    child: child,
                                                  );
                                                },
                                                loadingBuilder:
                                                    (context, child, loadingProgress) {
                                                  if (loadingProgress == null) {
                                                    return child;
                                                  }
                                                  return Container(
                                                    color: kPrimaryColor.withOpacity(0.08),
                                                    child: Center(
                                                      child: CircularProgressIndicator(
                                                        value: loadingProgress
                                                                    .expectedTotalBytes !=
                                                                null
                                                            ? loadingProgress
                                                                    .cumulativeBytesLoaded /
                                                                loadingProgress
                                                                    .expectedTotalBytes!
                                                            : null,
                                                        color: kPrimaryColor,
                                                        strokeWidth: 2,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                errorBuilder:
                                                    (context, error, stackTrace) {
                                                  if (kDebugMode) {
                                                    debugPrint(
                                                        'Home screen image error: $error');
                                                    debugPrint('Image URL: $imageUrl');
                                                  }
                                                  return Container(
                                                    color: kPrimaryColor.withOpacity(0.08),
                                                    child: Icon(
                                                      Icons.restaurant_menu_rounded,
                                                      color: kPrimaryColor.withOpacity(0.6),
                                                      size: 40,
                                                    ),
                                                  );
                                                },
                                              );
                                            }(),
                                          ),
                                          Positioned.fill(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                    Colors.black.withOpacity(0.05),
                                                    Colors.black.withOpacity(0.65),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 10,
                                            right: 10,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.black.withOpacity(0.55),
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                              ),
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                    Icons.thumb_up,
                                                    size: 14,
                                                    color: Colors.white,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    '${recipe.likesCount}',
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 11,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 10,
                                            right: 10,
                                            bottom: 10,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  recipe.title,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.access_time,
                                                      size: 14,
                                                      color: Colors.white70,
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      '${recipe.cookingTime} min',
                                                      style: const TextStyle(
                                                        color: Colors.white70,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
              ),
              const SizedBox(height: 22),
              const Text(
                'Most favorite',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 210,
                child: _buildMostFavoriteList(mostFavorite),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
