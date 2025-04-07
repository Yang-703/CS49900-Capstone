/* lib/Views/nav_bar_category.dart */
import 'package:flutter/material.dart';
import 'package:flutter_study_app/Views/leaderboard.dart';
import 'package:flutter_study_app/Views/profile_screen.dart';
import 'package:flutter_study_app/Views/field_screen.dart';
import 'package:flutter_study_app/Views/home.dart';

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

  // Pages list for the navigation items
  final List<Widget> pages = [
    const HomePage(),
    const FieldScreen(),
    const Leaderboard(),
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
      // Display the selected page
      body: PageStorage(
        bucket: bucket,
        child: pages[selectedIndex],
      ),
      backgroundColor: Colors.white,
      // Improved Bottom Navigation Bar with custom container
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          // Rounded top corners
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          // Subtle shadow for depth
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
            //topLeft: Radius.circular(20), //////////////////////////
            //topRight: Radius.circular(20), //////////////////////////
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