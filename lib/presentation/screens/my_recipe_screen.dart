import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rupp_final_mad/data/models/recipe.dart';
import 'package:rupp_final_mad/data/repositories/recipe_repository_impl.dart';
import 'package:rupp_final_mad/presentation/screens/recipe_detail_screen.dart';
import 'package:rupp_final_mad/presentation/widgets/skeleton_loader.dart';

// Color definitions (Reusing the brand colors)
const Color kPrimaryColor = Color(0xFF30A58B); // Teal/Sea Green

enum _RecipeViewFilter { all, favorites }

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
  String _searchQuery = ''; // Search query for filtering recipes
  String? _deletingId;
  bool _isCreating = false;
  _RecipeViewFilter _viewFilter = _RecipeViewFilter.all;

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

  // Filter recipes based on search query and selected tab
  List<Recipe> _getVisibleRecipes() {
    final source = _viewFilter == _RecipeViewFilter.favorites
        ? _favoriteRecipes
        : _recipes;
    if (_searchQuery.isEmpty) return source;

    return source
        .where((recipe) => recipe.title.toLowerCase().contains(_searchQuery))
        .toList();
  }

  Future<void> _loadUserRecipes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Load user recipes for "All" tab
      final recipes = await _recipeRepository.getUserRecipes();
      
      // Load all recipes to filter favorites (bookmarked recipes)
      // Load first few pages to get bookmarked recipes (optimized for performance)
      List<Recipe> allRecipes = [];
      int page = 1;
      bool hasMore = true;
      const maxPages = 5; // Load up to 5 pages (50 recipes) for favorites
      
      while (hasMore && page <= maxPages) {
        try {
          final pageRecipes = await _recipeRepository.getRecipes(page: page, limit: 10);
          allRecipes.addAll(pageRecipes);
          hasMore = pageRecipes.length == 10;
          page++;
        } catch (e) {
          debugPrint('Error loading favorites page $page: $e');
          break;
        }
      }
      
      setState(() {
        _recipes = recipes;
        // Filter favorites from all recipes where isBookmarked == true
        _favoriteRecipes = allRecipes.where((r) => r.isBookmarked).toList();
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

  Future<void> _confirmAndDelete(Recipe recipe) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete recipe?'),
        content: Text('Are you sure you want to delete "${recipe.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _deletingId = recipe.id;
    });

    try {
      await _recipeRepository.deleteRecipe(recipe.id);
      setState(() {
        _recipes.removeWhere((r) => r.id == recipe.id);
        _favoriteRecipes.removeWhere((r) => r.id == recipe.id);
        _deletingId = null;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Deleted "${recipe.title}"')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _deletingId = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete: ${e.toString()}')),
        );
      }
    }
  }

  void _openEditRecipeSheet(Recipe recipe) {
    final titleController = TextEditingController(text: recipe.title);
    final descriptionController =
        TextEditingController(text: recipe.description);
    final cookingTimeController =
        TextEditingController(text: recipe.cookingTime.toString());
    final servingsController =
        TextEditingController(text: recipe.servings.toString());
    final difficultyController = TextEditingController(text: recipe.difficulty);
    final cuisineController = TextEditingController(text: recipe.cuisine);
    final imageUrlController = TextEditingController(text: recipe.imageUrl);

    // Keep ingredient & instruction controllers alive for the entire bottom sheet
    final ingredientControllers = <TextEditingController>[
      for (final ing in recipe.ingredients) TextEditingController(text: ing),
      if (recipe.ingredients.isEmpty) TextEditingController(),
    ];
    final instructionControllers = <TextEditingController>[
      for (final step in recipe.instructions) TextEditingController(text: step),
      if (recipe.instructions.isEmpty) TextEditingController(),
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.9,
          child: StatefulBuilder(
            builder: (context, setModalState) {
              Future<void> submit() async {
                if (_isCreating) return;
                final title = titleController.text.trim();
                final desc = descriptionController.text.trim();
                if (title.isEmpty || desc.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Title and description are required')),
                  );
                  return;
                }

                final ingredients = ingredientControllers
                    .map((c) => c.text.trim())
                    .where((e) => e.isNotEmpty)
                    .toList();
                final instructions = instructionControllers
                    .map((c) => c.text.trim())
                    .where((e) => e.isNotEmpty)
                    .toList();
                // Require at least one ingredient and one instruction
                if (ingredients.isEmpty || instructions.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please add at least one ingredient and one instruction',
                      ),
                    ),
                  );
                  return;
                }
                setModalState(() => _isCreating = true);
                try {
                  final imageUrl = imageUrlController.text.trim();
                  final data = <String, dynamic>{
                    'title': title,
                    'description': desc,
                    'ingredients': ingredients,
                    'instructions': instructions,
                    'cookingTime':
                        int.tryParse(cookingTimeController.text) ?? 0,
                    'servings': int.tryParse(servingsController.text) ?? 1,
                    'difficulty': difficultyController.text.trim(),
                    'cuisine': cuisineController.text.trim(),
                    'tags': recipe.tags,
                    'imageUrl': imageUrl,
                  };

                  final updated =
                      await _recipeRepository.updateRecipe(recipe.id, data);
                  if (!mounted) return;
                  setState(() {
                    _recipes = _recipes
                        .map((r) => r.id == recipe.id ? updated : r)
                        .toList();
                    _favoriteRecipes = _favoriteRecipes
                        .map((r) => r.id == recipe.id ? updated : r)
                        .toList();
                  });
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Updated "${updated.title}"')),
                  );
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to update: $e')),
                    );
                  }
                } finally {
                  if (mounted) {
                    setModalState(() => _isCreating = false);
                  }
                }
              }

              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: 16,
                  right: 16,
                  top: 20,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Edit Recipe',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            margin: const EdgeInsets.only(right: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.close),
                              tooltip: 'Cancel',
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _buildTextField(titleController, 'Title',
                          icon: Icons.title, required: true),
                      _buildTextField(descriptionController, 'Description',
                          icon: Icons.description, maxLines: 2, required: true),
                      const SizedBox(height: 4),
                      const Text(
                        'Ingredients',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Column(
                        children: [
                          for (int i = 0; i < ingredientControllers.length; i++)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '${i + 1}.',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextField(
                                      controller: ingredientControllers[i],
                                      decoration: InputDecoration(
                                        hintText: 'Ingredient ${i + 1}',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        filled: true,
                                        fillColor: Colors.grey.shade100,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  if (ingredientControllers.length > 1)
                                    IconButton(
                                      icon: const Icon(
                                          Icons.remove_circle_outline,
                                          color: Colors.redAccent),
                                      tooltip: 'Remove ingredient',
                                      onPressed: () {
                                        setModalState(() {
                                          ingredientControllers
                                              .removeAt(i)
                                              .dispose();
                                        });
                                      },
                                    ),
                                ],
                              ),
                            ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton.icon(
                              onPressed: () {
                                setModalState(() {
                                  ingredientControllers
                                      .add(TextEditingController());
                                });
                              },
                              icon: const Icon(Icons.add),
                              label: const Text('Add ingredient'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Instructions',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Column(
                        children: [
                          for (int i = 0;
                              i < instructionControllers.length;
                              i++)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '${i + 1}.',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextField(
                                      controller: instructionControllers[i],
                                      maxLines: null,
                                      decoration: InputDecoration(
                                        hintText: 'Step ${i + 1}',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        filled: true,
                                        fillColor: Colors.grey.shade100,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  if (instructionControllers.length > 1)
                                    IconButton(
                                      icon: const Icon(
                                          Icons.remove_circle_outline,
                                          color: Colors.redAccent),
                                      tooltip: 'Remove step',
                                      onPressed: () {
                                        setModalState(() {
                                          instructionControllers
                                              .removeAt(i)
                                              .dispose();
                                        });
                                      },
                                    ),
                                ],
                              ),
                            ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton.icon(
                              onPressed: () {
                                setModalState(() {
                                  instructionControllers
                                      .add(TextEditingController());
                                });
                              },
                              icon: const Icon(Icons.add),
                              label: const Text('Add step'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _isCreating ? null : submit,
                          icon: _isCreating
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.check),
                          label:
                              Text(_isCreating ? 'Saving...' : 'Save changes'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _openCreateRecipeSheet() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final cookingTimeController = TextEditingController(text: '0');
    final servingsController = TextEditingController(text: '1');
    final difficultyController = TextEditingController(text: 'easy');
    final cuisineController = TextEditingController(text: 'general');

    // Keep ingredient & instruction controllers alive for the entire bottom sheet
    final ingredientControllers = <TextEditingController>[
      TextEditingController()
    ];
    final instructionControllers = <TextEditingController>[
      TextEditingController()
    ];

    // Create state variables outside builder to persist across rebuilds
    final selectedImages = <File>[];
    bool isUploadingImages = false;
    
    // Store parent context for showing snackbar after modal closes
    final parentContext = context;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: StatefulBuilder(
            builder: (context, setModalState) {

              Future<void> pickImages() async {
                try {
                  debugPrint('Opening image picker...');
                  final ImagePicker picker = ImagePicker();
                  
                  // Try to pick images - this will request permissions automatically on Android 13+
                  final List<XFile>? pickedFiles = await picker.pickMultiImage(
                    imageQuality: 85, // Compress images to reduce upload size
                  );
                  
                  if (pickedFiles != null && pickedFiles.isNotEmpty) {
                    debugPrint('Picked ${pickedFiles.length} images');
                    selectedImages.clear();
                    selectedImages.addAll(
                      pickedFiles.map((xFile) => File(xFile.path)),
                    );
                    debugPrint('Added ${selectedImages.length} images to list');
                    setModalState(() {}); // Trigger rebuild to show images
                  } else {
                    debugPrint('No images selected (user cancelled or no images)');
                  }
                } catch (e, stackTrace) {
                  debugPrint('Error picking images: $e');
                  debugPrint('Error type: ${e.runtimeType}');
                  debugPrint('Stack trace: $stackTrace');
                  
                  String errorMessage = 'Failed to pick images';
                  if (e.toString().contains('permission')) {
                    errorMessage = 'Permission denied. Please grant photo access in app settings.';
                  } else if (e.toString().contains('camera')) {
                    errorMessage = 'Camera access denied. Please grant camera permission.';
                  } else {
                    errorMessage = 'Failed to pick images: ${e.toString()}';
                  }
                  
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(errorMessage),
                        duration: const Duration(seconds: 4),
                        action: SnackBarAction(
                          label: 'OK',
                          onPressed: () {},
                        ),
                      ),
                    );
                  }
                }
              }

              Future<void> submit() async {
                if (_isCreating || isUploadingImages) return;
                final title = titleController.text.trim();
                final desc = descriptionController.text.trim();
                if (title.isEmpty || desc.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Title and description are required')),
                  );
                  return;
                }

                final ingredients = ingredientControllers
                    .map((c) => c.text.trim())
                    .where((e) => e.isNotEmpty)
                    .toList();
                final instructions = instructionControllers
                    .map((c) => c.text.trim())
                    .where((e) => e.isNotEmpty)
                    .toList();
                // Require at least one ingredient and one instruction
                if (ingredients.isEmpty || instructions.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please add at least one ingredient and one instruction',
                      ),
                    ),
                  );
                  return;
                }
                setModalState(() => _isCreating = true);
                try {
                  String imageUrl = '';
                  
                  // Upload images first if any are selected
                  if (selectedImages.isNotEmpty) {
                    isUploadingImages = true;
                    setModalState(() {}); // Update UI to show uploading state
                    
                    try {
                      // Upload images without recipe_id (empty string for new recipes)
                      final imageUrls = await _recipeRepository.uploadRecipeImages(
                        selectedImages,
                        recipeId: null, // Will send empty string for new recipe
                      );
                      // Use the first image URL as the main image
                      if (imageUrls.isNotEmpty) {
                        imageUrl = imageUrls.first;
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to upload images: $e')),
                        );
                      }
                      _isCreating = false;
                      isUploadingImages = false;
                      setModalState(() {});
                      return;
                    } finally {
                      isUploadingImages = false;
                      setModalState(() {});
                    }
                  }

                  final data = <String, dynamic>{
                    'title': title,
                    'description': desc,
                    'ingredients': ingredients,
                    'instructions': instructions,
                    'cookingTime':
                        int.tryParse(cookingTimeController.text) ?? 0,
                    'servings': int.tryParse(servingsController.text) ?? 1,
                    'difficulty': difficultyController.text.trim(),
                    'cuisine': cuisineController.text.trim(),
                    'tags': <String>[],
                    'imageUrl': imageUrl,
                  };

                  final created = await _recipeRepository.createRecipe(data);
                  if (!mounted) return;
                  
                  // Reset loading state before closing
                  setModalState(() {
                    _isCreating = false;
                  });
                  
                  // Update the recipes list
                  setState(() {
                    _recipes.insert(0, created);
                    if (created.isBookmarked) {
                      _favoriteRecipes.insert(0, created);
                    }
                  });
                  
                  // Close the modal
                  Navigator.of(context).pop();
                  
                  // Show success message using parent context
                  ScaffoldMessenger.of(parentContext).showSnackBar(
                    SnackBar(
                      content: Text('Recipe "${created.title}" created successfully!'),
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                } catch (e) {
                  if (mounted) {
                    setModalState(() {
                      _isCreating = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to create recipe: $e'),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  }
                }
              }

              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Add New Recipe',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed:
                              _isCreating ? null : () => Navigator.pop(context),
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildTextField(titleController, 'Title',
                        icon: Icons.title, required: true),
                    _buildTextField(descriptionController, 'Description',
                        icon: Icons.description, maxLines: 2, required: true),
                    const SizedBox(height: 4),
                    const Text(
                      'Ingredients',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Column(
                      children: [
                        for (int i = 0; i < ingredientControllers.length; i++)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '${i + 1}.',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    controller: ingredientControllers[i],
                                    decoration: InputDecoration(
                                      hintText: 'Ingredient ${i + 1}',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      filled: true,
                                      fillColor: Colors.grey.shade100,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                if (ingredientControllers.length > 1)
                                  IconButton(
                                    icon: const Icon(
                                        Icons.remove_circle_outline,
                                        color: Colors.redAccent),
                                    tooltip: 'Remove ingredient',
                                    onPressed: () {
                                      setModalState(() {
                                        ingredientControllers
                                            .removeAt(i)
                                            .dispose();
                                      });
                                    },
                                  ),
                              ],
                            ),
                          ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            onPressed: () {
                              setModalState(() {
                                ingredientControllers
                                    .add(TextEditingController());
                              });
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Add ingredient'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Instructions',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Column(
                      children: [
                        for (int i = 0; i < instructionControllers.length; i++)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '${i + 1}.',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    controller: instructionControllers[i],
                                    maxLines: null,
                                    decoration: InputDecoration(
                                      hintText: 'Step ${i + 1}',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      filled: true,
                                      fillColor: Colors.grey.shade100,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                if (instructionControllers.length > 1)
                                  IconButton(
                                    icon: const Icon(
                                        Icons.remove_circle_outline,
                                        color: Colors.redAccent),
                                    tooltip: 'Remove step',
                                    onPressed: () {
                                      setModalState(() {
                                        instructionControllers
                                            .removeAt(i)
                                            .dispose();
                                      });
                                    },
                                  ),
                              ],
                            ),
                          ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            onPressed: () {
                              setModalState(() {
                                instructionControllers
                                    .add(TextEditingController());
                              });
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Add step'),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            cookingTimeController,
                            'Cooking time (min)',
                            icon: Icons.timer,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTextField(
                            servingsController,
                            'Servings',
                            icon: Icons.people,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            difficultyController,
                            'Difficulty',
                            icon: Icons.whatshot,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTextField(
                            cuisineController,
                            'Cuisine',
                            icon: Icons.public,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Recipe Image',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    // Selected images display
                    if (selectedImages.isNotEmpty)
                      SizedBox(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: selectedImages.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.only(right: 8),
                              width: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                      selectedImages[index],
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: Material(
                                      color: Colors.black.withOpacity(0.5),
                                      shape: const CircleBorder(),
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        onPressed: () {
                                          selectedImages.removeAt(index);
                                          setModalState(() {}); // Trigger rebuild
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    // Image picker button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: pickImages,
                        icon: const Icon(Icons.add_photo_alternate),
                        label: Text(selectedImages.isEmpty
                            ? 'Select Images'
                            : 'Add More Images'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: kPrimaryColor,
                          side: const BorderSide(color: kPrimaryColor),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: (_isCreating || isUploadingImages) ? null : submit,
                        icon: (_isCreating || isUploadingImages)
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.check),
                        label: Text(
                          isUploadingImages
                              ? 'Uploading images...'
                              : _isCreating
                                  ? 'Creating...'
                                  : 'Create',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    IconData? icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    bool required = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label + (required ? ' *' : ''),
          prefixIcon: icon != null ? Icon(icon) : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: kPrimaryColor, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
        ),
      ),
    );
  }

  void _showFavoritesDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final favorites = _favoriteRecipes;
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 520),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      const Icon(Icons.favorite, color: Colors.red),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'My Favorites',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      )
                    ],
                  ),
                ),
                const Divider(height: 1),
                if (favorites.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: const [
                        Icon(Icons.favorite_border,
                            color: Colors.redAccent, size: 48),
                        SizedBox(height: 12),
                        Text(
                          'No favorites yet',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Bookmark recipes to see them here.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: favorites.length,
                      itemBuilder: (context, index) {
                        final recipe = favorites[index];
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              recipe.imageUrl,
                              width: 54,
                              height: 54,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 54,
                                  height: 54,
                                  decoration: BoxDecoration(
                                    color: kPrimaryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.restaurant,
                                    color: kPrimaryColor,
                                  ),
                                );
                              },
                            ),
                          ),
                          title: Text(
                            recipe.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          subtitle: Row(
                            children: [
                              const Icon(Icons.favorite,
                                  size: 14, color: Colors.redAccent),
                              const SizedBox(width: 4),
                              Text('${recipe.likesCount}'),
                              const SizedBox(width: 12),
                              Icon(Icons.access_time,
                                  size: 14, color: Colors.grey.shade600),
                              const SizedBox(width: 4),
                              Text(
                                '${recipe.cookingTime} min',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                            _navigateToDetail(recipe);
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRecipeCard(Recipe recipe) {
    final deleting = _deletingId == recipe.id;
    return GestureDetector(
      onTap: () => _navigateToDetail(recipe),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.network(
                        recipe.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: kPrimaryColor.withOpacity(0.06),
                          child: Icon(
                            Icons.restaurant_menu_rounded,
                            color: kPrimaryColor.withOpacity(0.6),
                            size: 52,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Material(
                        color: Colors.black.withOpacity(0.4),
                        shape: const CircleBorder(),
                        child: IconButton(
                          icon: const Icon(Icons.edit, color: Colors.white),
                          tooltip: 'Edit my recipe',
                          onPressed: () => _openEditRecipeSheet(recipe),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Material(
                        color: Colors.black.withOpacity(0.4),
                        shape: const CircleBorder(),
                        child: IconButton(
                          icon: deleting
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.delete_outline,
                                  color: Colors.white),
                          onPressed:
                              deleting ? null : () => _confirmAndDelete(recipe),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black54,
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              recipe.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.access_time,
                                    color: Colors.white.withOpacity(0.85),
                                    size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  '${recipe.cookingTime} min',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Icon(Icons.favorite,
                                    color: Colors.white, size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  '${recipe.likesCount}',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
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
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: kPrimaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.local_fire_department,
                                size: 16, color: kPrimaryColor),
                            const SizedBox(width: 6),
                            Text(
                              recipe.difficulty,
                              style: TextStyle(
                                color: kPrimaryColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.chevron_right, color: Colors.black54),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visibleRecipes = _getVisibleRecipes();
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadUserRecipes,
          displacement: 80,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [kPrimaryColor, Color(0xFF1E7F68)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: kPrimaryColor.withOpacity(0.35),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'My Recipes',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 26,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    'Create, curate and revisit your favorites.',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: _openCreateRecipeSheet,
                              icon: const Icon(Icons.add, color: kPrimaryColor),
                              label: const Text('Add'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: kPrimaryColor,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.16),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.12),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.menu_book_outlined,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${_recipes.length}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        const Text(
                                          'Total recipes',
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: InkWell(
                                onTap: _favoriteRecipes.isEmpty
                                    ? null
                                    : _showFavoritesDialog,
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.16),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.12),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.favorite,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${_favoriteRecipes.length}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                          Text(
                                            'Favorites',
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(
                                                  _favoriteRecipes.isEmpty
                                                      ? 0.45
                                                      : 0.8),
                                              fontSize: 12,
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 12,
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
                                controller: _searchController,
                                decoration: const InputDecoration(
                                  hintText: 'Search by recipe name...',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            if (_searchQuery.isNotEmpty)
                              IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  _onSearchChanged();
                                },
                              )
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          ChoiceChip(
                            label: const Text('All'),
                            selected: _viewFilter == _RecipeViewFilter.all,
                            onSelected: (_) => setState(
                                () => _viewFilter = _RecipeViewFilter.all),
                            selectedColor: kPrimaryColor.withOpacity(0.15),
                            labelStyle: TextStyle(
                              color: _viewFilter == _RecipeViewFilter.all
                                  ? kPrimaryColor
                                  : Colors.grey.shade700,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 10),
                          ChoiceChip(
                            label: const Text('Favorites'),
                            selected:
                                _viewFilter == _RecipeViewFilter.favorites,
                            onSelected: (_) => setState(() =>
                                _viewFilter = _RecipeViewFilter.favorites),
                            selectedColor: Colors.red.withOpacity(0.14),
                            labelStyle: TextStyle(
                              color: _viewFilter == _RecipeViewFilter.favorites
                                  ? Colors.red.shade400
                                  : Colors.grey.shade700,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Spacer(),
                          TextButton.icon(
                            onPressed: _openCreateRecipeSheet,
                            icon: const Icon(Icons.auto_awesome,
                                color: kPrimaryColor),
                            label: const Text('Quick add'),
                            style: TextButton.styleFrom(
                              foregroundColor: kPrimaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
              ),
              if (_isLoading)
                SliverPadding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => const RecipeListItemSkeleton(),
                      childCount: 5,
                    ),
                  ),
                )
              else if (_errorMessage.isNotEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 80,
                            color: Colors.red.withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _errorMessage,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(height: 18),
                          ElevatedButton(
                            onPressed: _loadUserRecipes,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimaryColor,
                              foregroundColor: Colors.white,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 26),
                            ),
                            child: const Text('Retry'),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              else if (visibleRecipes.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _searchQuery.isNotEmpty
                              ? Icons.search_off
                              : Icons.restaurant_menu,
                          size: 88,
                          color: kPrimaryColor.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isNotEmpty
                              ? 'No recipes found'
                              : 'No recipes yet',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0),
                          child: Text(
                            _searchQuery.isNotEmpty
                                ? 'Try another keyword or switch tabs.'
                                : "Tap 'Add' or 'Quick add' to start building your cookbook.",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 16),
                        OutlinedButton.icon(
                          onPressed: _openCreateRecipeSheet,
                          icon: const Icon(Icons.add_circle_outline),
                          label: const Text('Create your first recipe'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: kPrimaryColor,
                            side: const BorderSide(color: kPrimaryColor),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) =>
                          _buildRecipeCard(visibleRecipes[index]),
                      childCount: visibleRecipes.length,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.78,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
