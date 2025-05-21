/* lib/Views/home.dart final*/
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_study_app/Service/shop_service.dart';
import 'package:flutter_study_app/Widgets/snackbar.dart';
import 'package:flutter_study_app/Service/my_courses_service.dart'; 
import 'login_screen.dart';
import 'contact.dart'; 
import 'settings.dart';
import 'field_screen.dart';
import 'course_detail_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

const Map<String,String> petAssets = {
  'pet_elephant' : 'assets/mascot1.png',
  'pet_puppy': 'assets/mascot2.png',
  'pet_cat': 'assets/mascot3.png',
};

class _HomePageState extends State<HomePage> {
  final User? user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? userData;
  Uint8List? profileImageBytes;
  bool isLoading = true;
  int highestStreak = 0;

  String formatTimeSpent(int seconds) {
      if (seconds < 3600) {
      return '< 1 hour';
    } else if (seconds < 86400) {
      final hours = seconds ~/ 3600;
      return '$hours hour${hours > 1 ? 's' : ''}';
    } else {
      final days = seconds ~/ 86400;
      return '$days day${days > 1 ? 's' : ''}';
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    if (user == null) return;
    try {
      final snap =
          await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
      if (snap.exists) {
        setState(() {
          userData = snap.data();
          if (userData?['photoBase64'] != null) {
            profileImageBytes = base64Decode(userData!['photoBase64']);
          }
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        showSnackBar(context, 'No user data found.');
      }
    } catch (e) {
      setState(() => isLoading = false);
      showSnackBar(context, 'Failed to fetch user data: $e');
    }
  }

  Future<void> _signOut() async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF4185D3),
        title: const Text('Sign Out',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to sign out?',
            style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No', style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (!mounted) return;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LogInScreen()),
              );
            },
            child: const Text('Yes', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDE7FD), // Update background color here
      appBar: AppBar(
        title: const Text('Home', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent, // Make the AppBar background transparent
        elevation: 0,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Padding(
              padding: EdgeInsets.only(left: 12.0),
              child: Icon(Icons.menu, color: Colors.white),
            ),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF7CB0FC), // Start color 0xFF7CB0FC
                const Color(0xFF638FDB), // End color
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      drawer: _buildDrawer(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildBody(),
    );
  }

  Widget _buildBody() {
    return StreamBuilder<List<CourseProgress>>(
      stream: MyCoursesService.myCoursesStream(),
      builder: (context, snapshot) {
        final courses = snapshot.data ?? [];
        final inProgress = courses.where((c) =>
            c.totalItems > 0 && c.completedItems < c.totalItems).toList();
        final completed = courses.where((c) =>
            c.totalItems > 0 && c.completedItems >= c.totalItems).toList();

        return ListView(
          padding: const EdgeInsets.only(bottom: 100),
          children: [
            const SizedBox(height: 20),
            _greetings(),
            const SizedBox(height: 5),
            _welcomeCard(),
            const SizedBox(height: 40),
            _sectionTitle('Your Progress'),
            if (inProgress.isEmpty)
              _emptyMessage('You have no ongoing courses.\nStart learning today!')
            else
              _coursesCarousel(inProgress),
            if (completed.isNotEmpty) ...[
              const SizedBox(height: 40),
              _sectionTitle('Completed'),
              _coursesCarousel(completed, completedSection: true),
            ],
            const SizedBox(height: 40),
            _userReport(),
          ],
        );
      },
    );
  }

  Widget _greetings() {
    return Container(
      padding: const EdgeInsets.only(left: 25.0),
      child: Text(
        'Good Morning, ${userData?['name'] ?? ''}!',
        style: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Color(0xFF333333),
        ),
      ),
    );
  }

  Widget _welcomeCard() {
    return Container(
      height: MediaQuery.of(context).size.height / 4,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        gradient: LinearGradient(
          colors: [
            Color(0xFFF98293), // Start color
            Color(0xFFF34C69), // End color
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      margin: const EdgeInsets.only(left: 85, right: 45, top: 25),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Image (overlapping)
          Positioned(
            left: -65,
            top: 10,
            child: GestureDetector(
              onTap: () => _showPetPickerDialog(context),
              child: Image.asset(
                'assets/mascot1.png',
                height: MediaQuery.of(context).size.height / 4.5,
              ),
            ),
          ),
          // Text and Button
          Padding(
            padding: const EdgeInsets.only(left: 170, top: 20, right: 20, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daily Quiz',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Continue your daily streak!',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                  ),
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const FieldScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFFF55F79),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text('Go!'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _userReport() {
    final int secondsSpent = userData?['timeSpent'] ?? 0;
    final timeSpent = formatTimeSpent(secondsSpent);

    final int exercisesDone = userData?['exercisesDone'] ?? 0;
    final int highestStreak = userData?['highestStreak'] ?? 0; // <-- updated here

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF06FBD8), Color(0xFF44D3AE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${userData?['name'] ?? 'User'}'s Report",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _statCard('Time Spent', timeSpent, Icons.access_time),
                const VerticalDivider(
                  color: Colors.white,
                  thickness: 1,
                  width: 20,
                  indent: 10,
                  endIndent: 10,
                ),
                _statCard('Exercises Done', '$exercisesDone', Icons.book),
                const VerticalDivider(
                  color: Colors.white,
                  thickness: 1,
                  width: 20,
                  indent: 10,
                  endIndent: 10,
                ),
                _statCard('Highest Streak', '$highestStreak', Icons.whatshot), // <-- changed label + icon
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String title, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 30,
            color: Colors.white,
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(fontSize: 14, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Text(text,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      );

  Widget _emptyMessage(String msg) => Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Text(msg,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.grey)),
      );

  Widget _coursesCarousel(List<CourseProgress> list,
      {bool completedSection = false}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: FlutterCarousel(
        options: FlutterCarouselOptions(
          height: 220,
          enlargeCenterPage: true,
          enableInfiniteScroll: false,
        ),
        items: list
            .map((c) => _courseCard(c, completed: completedSection))
            .toList(),
      ),
    );
  }

  Widget _courseCard(CourseProgress cp, {bool completed = false}) {
    final double progress =
      cp.totalItems == 0 ? 0.0 : cp.completedItems / cp.totalItems;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CourseDetailScreen(
              fieldName: cp.fieldName,
              courseName: cp.courseName,
              courseData: cp.courseData,
            ),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: cp.imageUrl.isNotEmpty
                    ? Image.network(
                      cp.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _placeholder())
                    : _placeholder(),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(cp.courseName,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                if (completed)
                  Row(
                    children: const [
                      Icon(Icons.check_circle,
                          color: Colors.green, size: 18),
                      SizedBox(width: 4),
                      Text('Completed',
                          style:
                              TextStyle(fontSize: 14, color: Colors.green)),
                    ],
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LinearProgressIndicator(
                        value: progress,
                        minHeight: 6,
                        backgroundColor: Colors.grey.shade300,
                        color: Colors.blueAccent,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${(progress * 100).toStringAsFixed(0)}% completed • ${cp.fieldName}',
                        style: const TextStyle(fontSize: 12),
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

  Widget _placeholder() => Container(
        color: Colors.grey.shade300,
        child: const Center(child: Icon(Icons.book, size: 40)),
      );

  Drawer _buildDrawer() {
    return Drawer(
      backgroundColor: const Color(0xFF4E8ACF),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const SizedBox(height: 120),
              _drawerTile(Icons.settings, 'Settings', () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const SettingsPage()));
              }),
              _drawerTile(Icons.info, 'Contact Us', () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ContactPage()));
              }),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, bottom: 25),
            child: _drawerTile(Icons.logout, 'Sign Out', _signOut),
          ),
        ],
      ),
    );
  }

  Widget _drawerTile(IconData icon, String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        onTap: onTap,
      ),
    );
  }

  Future<void> _showPetPickerDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Choose your pet'),
        content: StreamBuilder<Set<String>>(
          stream: ShopService.inventoryStream(),
          builder: (context, invSnap) {
            final owned = invSnap.data ?? <String>{};
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Image.asset('assets/mascot1.png', width: 40, height: 40),
                  title: const Text('Default'),
                  onTap: () {
                    ShopService.selectPet(null);
                    Navigator.pop(ctx);
                  },
                ),
                ...owned
                  .where((id) => petAssets.containsKey(id))
                  .map((id) {
                    final asset = petAssets[id]!;
                    final item = ShopService.allItems.firstWhere((i) => i.id == id);
                    return ListTile(
                      leading: Image.asset(asset, width: 40, height: 40),
                      title: Text(item.name),
                      onTap: () {
                        ShopService.selectPet(id);
                        Navigator.pop(ctx);
                      },
                    );
                  }),
              ],
            );
          },
        ),
      ),
    );
  }
}