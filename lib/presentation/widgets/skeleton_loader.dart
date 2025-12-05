import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonLoader extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const SkeletonLoader({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
      ),
    );
  }
}

class RecipeCardSkeleton extends StatelessWidget {
  const RecipeCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image skeleton
          SkeletonLoader(
            width: double.infinity,
            height: 200,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title skeleton
                SkeletonLoader(width: double.infinity, height: 20),
                const SizedBox(height: 8),
                // Description skeleton
                SkeletonLoader(width: double.infinity, height: 16),
                const SizedBox(height: 8),
                SkeletonLoader(width: 200, height: 16),
                const SizedBox(height: 12),
                // Meta info skeleton
                Row(
                  children: [
                    SkeletonLoader(width: 80, height: 14),
                    const SizedBox(width: 16),
                    SkeletonLoader(width: 100, height: 14),
                    const Spacer(),
                    SkeletonLoader(width: 40, height: 14),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RecipeListItemSkeleton extends StatelessWidget {
  const RecipeListItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Image skeleton
            SkeletonLoader(
              width: 60,
              height: 60,
              borderRadius: BorderRadius.circular(10),
            ),
            const SizedBox(width: 12),
            // Text skeleton
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonLoader(width: double.infinity, height: 16),
                  const SizedBox(height: 8),
                  SkeletonLoader(width: 150, height: 14),
                  const SizedBox(height: 8),
                  SkeletonLoader(width: 100, height: 12),
                ],
              ),
            ),
            SkeletonLoader(
                width: 24, height: 24, borderRadius: BorderRadius.circular(12)),
          ],
        ),
      ),
    );
  }
}
