/* lib/Views/nav_bar_category.dart */
import 'package:flutter/material.dart';
import 'home.dart';
import 'field_screen.dart';
import 'leaderboard.dart';
import 'shop_screen.dart';
import 'profile_screen.dart';

class NavBarCategorySelection extends StatefulWidget {
  final int initialIndex;
  const NavBarCategorySelection({super.key, this.initialIndex = 0});

  @override
  State<NavBarCategorySelection> createState() =>
      _NavBarCategorySelectionState();
}

class _NavBarCategorySelectionState
    extends State<NavBarCategorySelection> {
  final PageStorageBucket bucket = PageStorageBucket();

  final List<Widget> pages = [
    const HomePage(),
    const FieldScreen(),
    const Leaderboard(),
    const ShopScreen(),
    const ProfileScreen(),
  ];

  late int selectedIndex;

  @override
  void initState() {
    selectedIndex = widget.initialIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        bucket: bucket,
        child: pages[selectedIndex],
      ),
      backgroundColor: Colors.white,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 1,
              blurRadius: 10,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            currentIndex: selectedIndex,
            onTap: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
            selectedItemColor: Colors.blueAccent,
            unselectedItemColor: Colors.grey,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            iconSize: 30,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.book),
                label: 'Courses',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.leaderboard),
                label: 'Leaderboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                label: 'Shop',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}