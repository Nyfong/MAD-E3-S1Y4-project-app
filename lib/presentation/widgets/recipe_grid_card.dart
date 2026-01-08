import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:rupp_final_mad/data/models/recipe.dart';
import 'package:rupp_final_mad/data/api/api_config.dart';

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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 900;

    final mainImageUrl = _resolveImageUrl(recipe.imageUrl);
    final authorPhoto = (recipe.authorPhotoURL.isNotEmpty && 
                        recipe.authorPhotoURL != 'string')
        ? _resolveImageUrl(recipe.authorPhotoURL)
        : null;
    
    // Debug: Print image URL to help diagnose issues
    if (kDebugMode && mainImageUrl.isNotEmpty) {
      debugPrint('RecipeGridCard: Loading image from: $mainImageUrl');
    }

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
          children: [
            // Top bar: author row (Instagram-style)
            Padding(
              padding: EdgeInsets.all(isLargeScreen ? 12.0 : 10.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: isLargeScreen ? 14 : 13,
                    backgroundColor: kPrimaryColor.withOpacity(0.15),
                    backgroundImage: (authorPhoto != null && 
                                     authorPhoto.isNotEmpty && 
                                     authorPhoto != 'string')
                        ? NetworkImage(authorPhoto)
                        : null,
                    child: (authorPhoto == null || 
                            authorPhoto.isEmpty || 
                            authorPhoto == 'string')
                        ? Icon(
                            Icons.person,
                            size: isLargeScreen ? 16 : 15,
                            color: kPrimaryColor,
                          )
                        : null,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      recipe.authorName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: isLargeScreen ? 13 : 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Main image (takes remaining height)
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (mainImageUrl.isNotEmpty && mainImageUrl != 'string')
                    Image.network(
                      mainImageUrl,
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
                        debugPrint('Image load error for URL: $mainImageUrl');
                        debugPrint('Error: $error');
                        return Container(
                          color: kPrimaryColor.withOpacity(0.1),
                          child: const Icon(
                            Icons.restaurant_menu,
                            size: 40,
                            color: kPrimaryColor,
                          ),
                        );
                      },
                    )
                  else
                    Container(
                      color: kPrimaryColor.withOpacity(0.1),
                      child: const Icon(
                        Icons.restaurant_menu,
                        size: 40,
                        color: kPrimaryColor,
                      ),
                    ),
                ],
              ),
            ),
            // Bottom: title + stats row (likes, time)
            Padding(
              padding: EdgeInsets.fromLTRB(
                isLargeScreen ? 12.0 : 10.0,
                isLargeScreen ? 8.0 : 6.0,
                isLargeScreen ? 12.0 : 10.0,
                isLargeScreen ? 10.0 : 8.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    recipe.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: isLargeScreen ? 14 : 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: isLargeScreen ? 6 : 4),
                  Row(
                    children: [
                      Icon(
                        Icons.thumb_up_outlined,
                        size: isLargeScreen ? 15 : 14,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatCount(recipe.likesCount),
                        style: TextStyle(
                          fontSize: isLargeScreen ? 12 : 11,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.access_time,
                        size: isLargeScreen ? 15 : 14,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${recipe.cookingTime} min',
                        style: TextStyle(
                          fontSize: isLargeScreen ? 12 : 11,
                          color: Colors.grey.shade700,
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
    );
  }
}
