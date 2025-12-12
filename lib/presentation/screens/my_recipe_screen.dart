import 'package:flutter/material.dart';

const Color kPrimaryColor = Color(0xFF30A58B); // Mint/Teal color

class MyRecipeScreen extends StatefulWidget {
  const MyRecipeScreen({super.key});

  @override
  State<MyRecipeScreen> createState() => _MyRecipeScreenState();
}

class _MyRecipeScreenState extends State<MyRecipeScreen> {
  // Initial list of cookbooks (categories)
  final List<Map<String, dynamic>> _cookbooks = [
    {
      'title': 'Imported recipes',
      'count': 0,
      'icon': Icons.language, // Globe
      'iconColor': const Color(0xFF7E2E85), // Purple
      'backgroundColor': const Color(0xFFF9EEF6), // Light Purple
      'isNew': true,
      'badgeColor': const Color(0xFF7E2E85),
    },
    {
      'title': 'My favourite recipes',
      'count': 0,
      'icon': Icons.favorite,
      'iconColor': const Color(0xFFFF6B2C), // Orange
      'backgroundColor': const Color(0xFFFFF5EA), // Light Orange
    },
  ];

  Future<void> _navigateToCreateCookbook() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateCookbookScreen()),
    );

    if (result != null && result is String && result.isNotEmpty) {
      setState(() {
        _cookbooks.add({
          'title': result,
          'count': 0, // Initial count
          'icon': Icons.book, // Default icon for user cookbooks
          'iconColor': kPrimaryColor, // Use Mint for consistency
          'backgroundColor': const Color(0xFFE0F2F1), // Light Mint background
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'My Recipes',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: kPrimaryColor, // Mint color
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: _navigateToCreateCookbook,
            icon: const Icon(Icons.add, color: kPrimaryColor, size: 30), // Mint color
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(), // Scroll handled by SingleChildScrollView
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 24,
              childAspectRatio: 0.7, // Adjust to fit card + text
            ),
            itemCount: _cookbooks.length,
            itemBuilder: (context, index) {
              final cookbook = _cookbooks[index];
              return _buildCategoryItem(
                title: cookbook['title'],
                count: cookbook['count'],
                icon: cookbook['icon'],
                iconColor: cookbook['iconColor'],
                backgroundColor: cookbook['backgroundColor'],
                isNew: cookbook['isNew'] ?? false,
                badgeColor: cookbook['badgeColor'],
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreateCookbook,
        backgroundColor: kPrimaryColor, // Mint theme
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
    );
  }
  Widget _buildCategoryItem({
    required String title,
    required int count,
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    bool isNew = false,
    Color? badgeColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // The colored container
        Expanded(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Center(
                  child: Icon(
                    icon,
                    size: 40,
                    color: iconColor,
                  ),
                ),
              ),
              if (isNew)
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: badgeColor ?? iconColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'New',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Title
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            height: 1.2,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        // Count
        Text(
          '$count recipes',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}

class CreateCookbookScreen extends StatefulWidget {
  const CreateCookbookScreen({super.key});

  @override
  State<CreateCookbookScreen> createState() => _CreateCookbookScreenState();
}

class _CreateCookbookScreenState extends State<CreateCookbookScreen> {
  final TextEditingController _titleController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Create a cookbook',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Save action: return the text
              Navigator.pop(context, _titleController.text);
            },
            child: const Text(
              'Save',
              style: TextStyle(
                color: kPrimaryColor, // Mint color
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Title',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Title',
                hintStyle: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 16,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.grey.shade300,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.grey.shade300,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}