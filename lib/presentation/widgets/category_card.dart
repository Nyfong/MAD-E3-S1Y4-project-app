// File: lib/widgets/category_card.dart

import 'package:flutter/material.dart';

// Color definitions (Ensure these are defined here, in a theme file, or imported)
const Color kPrimaryColor = Color(0xFF30A58B); // Teal/Sea Green

class CategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;

  const CategoryCard({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      // Consistent, large rounded corners (15)
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      // Increased elevation and shadow for depth, using branded color
      elevation: 6,
      shadowColor: kPrimaryColor.withOpacity(0.3),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Branded icon color
              Icon(icon, size: 48, color: kPrimaryColor),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}