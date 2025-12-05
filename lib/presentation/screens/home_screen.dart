import 'package:flutter/material.dart';
import 'package:rupp_final_mad/presentation/screens/explore_screen.dart';
import 'package:rupp_final_mad/presentation/screens/my_recipe_screen.dart';
import 'package:rupp_final_mad/presentation/screens/profile_screen.dart';
import 'package:rupp_final_mad/presentation/screens/home_tab_screen.dart';

const Color kPrimaryColor = Color(0xFF30A58B);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const HomeTabScreen(),
      const ExploreScreen(),
      const MyRecipeScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      appBar: null,
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Colors.white,
        elevation: 4,
        indicatorColor: kPrimaryColor.withOpacity(0.2),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: kPrimaryColor),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore, color: kPrimaryColor),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.restaurant_menu_outlined),
            selectedIcon: Icon(Icons.restaurant_menu, color: kPrimaryColor),
            label: 'My Recipe',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: kPrimaryColor),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
