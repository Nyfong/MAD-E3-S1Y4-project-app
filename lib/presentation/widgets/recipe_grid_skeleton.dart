import 'package:flutter/material.dart';
import 'package:rupp_final_mad/presentation/widgets/skeleton_loader.dart';

class RecipeGridSkeleton extends StatelessWidget {
  const RecipeGridSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image skeleton
          Expanded(
            flex: 3,
            child: SkeletonLoader(
              width: double.infinity,
              height: double.infinity,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
          ),
          // Content skeleton
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonLoader(width: double.infinity, height: 14),
                  const SizedBox(height: 4),
                  Flexible(
                    child: SkeletonLoader(width: double.infinity, height: 11),
                  ),
                  const SizedBox(height: 4),
                  SkeletonLoader(width: 80, height: 11),
                  const Spacer(),
                  Wrap(
                    spacing: 4,
                    children: [
                      SkeletonLoader(width: 40, height: 16),
                      SkeletonLoader(width: 50, height: 16),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}



