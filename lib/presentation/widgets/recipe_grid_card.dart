import 'package:flutter/material.dart';
import 'package:rupp_final_mad/data/models/recipe.dart';

const Color kPrimaryColor = Color(0xFF30A58B);

class RecipeGridCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onTap;

  const RecipeGridCard({
    super.key,
    required this.recipe,
    required this.onTap,
  });

  String _formatCount(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return count.toString();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 900;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image Section
            Expanded(
              flex: 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    recipe.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: kPrimaryColor.withOpacity(0.1),
                        child: const Icon(
                          Icons.restaurant_menu,
                          size: 40,
                          color: kPrimaryColor,
                        ),
                      );
                    },
                  ),
                  // Gradient overlay for better text readability
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: isLargeScreen ? 10 : 8,
                        vertical: isLargeScreen ? 6 : 5,
                      ),
                      child: SafeArea(
                        top: false,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Likes
                            Flexible(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.favorite,
                                    size: isLargeScreen ? 14 : 12,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      _formatCount(recipe.likesCount),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: isLargeScreen ? 12 : 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Cooking time
                            Flexible(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    size: isLargeScreen ? 14 : 12,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      '${recipe.cookingTime}m',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: isLargeScreen ? 12 : 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content Section
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(isLargeScreen ? 12.0 : 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    Flexible(
                      flex: 2,
                      child: Text(
                        recipe.title,
                        style: TextStyle(
                          fontSize: isLargeScreen ? 15 : 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: isLargeScreen ? 6 : 4),
                    // Description
                    Flexible(
                      flex: 2,
                      child: Text(
                        recipe.description,
                        style: TextStyle(
                          fontSize: isLargeScreen ? 12 : 11,
                          color: Colors.grey.shade600,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: isLargeScreen ? 8 : 6),
                    // Tags
                    Flexible(
                      flex: 1,
                      child: Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        alignment: WrapAlignment.start,
                        children: recipe.tags.take(2).map((tag) {
                          return Container(
                            constraints: BoxConstraints(
                              maxWidth: isLargeScreen ? 100 : 80,
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: isLargeScreen ? 8 : 6,
                              vertical: isLargeScreen ? 4 : 3,
                            ),
                            decoration: BoxDecoration(
                              color: kPrimaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              tag,
                              style: TextStyle(
                                fontSize: isLargeScreen ? 10 : 9,
                                color: kPrimaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
