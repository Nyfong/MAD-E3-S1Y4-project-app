// File: lib/presentation/widgets/home_app_bar_content.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Teal/Sea Green color
const Color kPrimaryColor = Color(0xFF30A58B);

class HomeAppBarContent extends StatelessWidget {
  final String userName;

  const HomeAppBarContent({
    super.key,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateFormat = DateFormat('EEE, d MMM');
    final dateGreeting = dateFormat.format(now);
    final userFirstName = userName.split(' ').first;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 1. App Title
        const Text(
          'Recipe App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: kPrimaryColor,
          ),
        ),

        // 2. Simple User Greeting
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Hello, $userFirstName!',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            Text(
              dateGreeting,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}