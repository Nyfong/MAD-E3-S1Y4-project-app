import 'package:flutter/material.dart';
import 'package:rupp_final_mad/presentation/widgets/skeleton_loader.dart';

class RecipeGridSkeleton extends StatelessWidget {
  const RecipeGridSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
          // Background Skeleton
          const SkeletonLoader(
            width: double.infinity,
            height: double.infinity,
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
          
          // Badge Skeleton
          Positioned(
            top: 12,
            right: 12,
            child: SkeletonLoader(
              width: 50,
              height: 24,
              borderRadius: BorderRadius.circular(20),
            ),
          ),

          // Bottom Content Skeleton
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SkeletonLoader(width: double.infinity, height: 18),
                const SizedBox(height: 8),
                const SkeletonLoader(width: 80, height: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
