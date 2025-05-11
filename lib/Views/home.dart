/* lib/Views/home.dart */
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
import 'course_detail_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

const Map<String,String> petAssets = {
  'pet_puppy': 'assets/mascot2.png',
};

class _HomePageState extends State<HomePage> {
  final User? user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? userData;
  Uint8List? profileImageBytes;
  bool isLoading = true;

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:
            const Text('Home', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
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
          c.totalItems > 0 &&
          c.completedItems < c.totalItems
        ).toList();

        final completed = courses.where((c) =>
          c.totalItems > 0 &&
          c.completedItems >= c.totalItems
        ).toList();

        return ListView(
          padding: const EdgeInsets.only(bottom: 40),
          children: [
            const SizedBox(height: 20),
            _welcomeCard(),
            const SizedBox(height: 40),
            _sectionTitle('In Progress'),
            if (inProgress.isEmpty)
              _emptyMessage('You have no ongoing courses.\nStart learning today!')
            else
              _coursesCarousel(inProgress),
            if (completed.isNotEmpty) ...[
              const SizedBox(height: 40),
              _sectionTitle('Completed'),
              _coursesCarousel(completed, completedSection: true),
            ],
          ],
        );
      },
    );
  }

  Widget _welcomeCard() {
    return Align(
      alignment: const Alignment(0, 2),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Color(0xFF6E6E6E),
              spreadRadius: 2,
              blurRadius: 2,
              offset: Offset(5, 5),
            ),
          ],
          gradient: const RadialGradient(
            colors: [Color(0xFF8BDAFF), Color(0xFF849AFF)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Welcome, ${userData?['name'] ?? ''}!',
                style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () => _showPetPickerDialog(context),
                child: StreamBuilder<String?>(
                  stream: ShopService.selectedPetStream(),
                  builder: (ctx, snap) {
                    final petId = snap.data;
                    final asset = petAssets[petId] ?? 'assets/mascot.png';
                    return Image.asset(asset, fit: BoxFit.cover, height: 180);
                  },
                ),
              ),
            ],
          ),
        ),
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
                  leading: Image.asset('assets/mascot.png', width: 40, height: 40),
                  title: const Text('Default Mascot'),
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