/* lib/Views/profile_screen.dart */
import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_study_app/Widgets/my_button.dart';
import 'package:flutter_study_app/Widgets/snackbar.dart';
import 'package:flutter_study_app/Service/streak_service.dart';
import 'package:flutter_study_app/Service/shop_service.dart';
import 'package:flutter_study_app/Views/inventory_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key}); 

  @override
  State<ProfileScreen> createState() => _ProfileScreenState(); 
}

class _ProfileScreenState extends State<ProfileScreen> {
  final User? user = FirebaseAuth.instance.currentUser;

  bool isLoading = true;
  Map<String, dynamic>? users;
  Uint8List? profileImageBytes;
  int currentStreak = 0;
  int highestStreak = 0;

  @override
  void initState() {
    super.initState();
    StreakService.syncStreak();

    fetchUserData();

    StreakService.currentStreakStream().listen((val) {
      if (mounted) setState(() => currentStreak = val);
    });
    StreakService.highestStreakStream().listen((val) {
      if (mounted) setState(() => highestStreak = val);
    });
  }

  Future<void> fetchUserData() async {
    if (user == null) return;
    try {
      final snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      if (snap.exists) {
        setState(() {
          users = snap.data();
          if (users?['photoBase64'] != null) {
            profileImageBytes = base64Decode(users!['photoBase64']);
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

  Future<void> updateProfileImage(Uint8List imageBytes) async {
    if (user == null) return;
    try {
      final b64 = base64Encode(imageBytes);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .set({'photoBase64': b64}, SetOptions(merge: true));
      setState(() => profileImageBytes = imageBytes);
      showSnackBar(context, 'Profile image updated');
    } catch (e) {
      showSnackBar(context, 'Failed to update image: $e');
    }
  }

  Future<void> pickImageFromGallery() async {
    final img = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (img == null) return;
    final bytes = await img.readAsBytes();
    await updateProfileImage(bytes);
  }

  Future<void> signOut() async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF4E8ACF),
        title: const Text("You're about to sign out.",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to continue?',
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
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF7CB0FC),
                Color(0xFF638FDB),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        color: const Color(0xFFDDE7FD),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : users == null
                ? const Center(child: Text('No user data found'))
                : Padding(
                    padding: const EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: pickImageFromGallery,
                            child: StreamBuilder<Set<String>>(
                              stream: ShopService.inventoryStream(),
                              builder: (context, invSnap) {
                                final inv = invSnap.data ?? {};
                                final hasFrame = inv.contains('frame_gold');
                                return Container(
                                  padding: hasFrame ? const EdgeInsets.all(0) : EdgeInsets.zero,
                                  decoration: hasFrame
                                      ? BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(color: Colors.amber, width: 5),
                                        )
                                      : null,
                                  child: CircleAvatar(
                                    radius: 60,
                                    backgroundColor: Colors.blue[100],
                                    backgroundImage: profileImageBytes != null
                                        ? MemoryImage(profileImageBytes!)
                                        : const NetworkImage(
                                            'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png'),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            users?['name'] ?? 'No Name',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF638FDB), // matching end gradient color for consistency
                            ),
                          ),
                          const SizedBox(height: 10),
                          _statChip(
                            icon: Icons.star,
                            label: 'Stars',
                            value: users?['stars'] ?? 0,
                            gradientColors: [Color.fromARGB(255, 235, 215, 129), Color(0xFFFBC02D)],  // golden yellow gradient
                          ),
                          const SizedBox(height: 10),
                          _statChip(
                            icon: Icons.monetization_on,
                            label: 'Coins',
                            value: users?['coins'] ?? 0,
                            gradientColors: [Color.fromARGB(255, 129, 223, 134), Color.fromARGB(255, 88, 170, 92)],  // green gradient
                          ),
                          const SizedBox(height: 10),
                          _statChip(
                            icon: Icons.local_fire_department,
                            label: 'Current Streak',
                            value: currentStreak,
                            suffix: currentStreak == 1 ? ' day' : ' days',
                            gradientColors: [Color(0xFFFF8A65), Color(0xFFF4511E)],  // orange gradient
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: Card(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              elevation: 4,
                              clipBehavior: Clip.antiAlias,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const InventoryScreen()),
                                  );
                                },
                                child: Container(
                                  height: 80,
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Color.fromARGB(255, 129, 164, 212), Color.fromARGB(255, 58, 127, 196)], // deeper blue tones
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: const ListTile(
                                    leading: Icon(Icons.inventory, size: 32, color: Colors.white),
                                    title: Text(
                                      'Inventory',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    subtitle: Text(
                                      'View the items you bought',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Divider(thickness: 1),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: MyButton(
                              onTap: signOut,
                              buttonText: 'Sign Out',
                            ),
                          ),
                          _userReport(),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }

  Widget _statChip({
    required IconData icon,
    required String label,
    required int value,
    String suffix = '',
    required List<Color> gradientColors, 
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(width: 8),
          Text(
            '$label: $value$suffix',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _userReport() {
    final int secondsSpent = users?['timeSpent'] ?? 0;
    final timeSpent = formatTimeSpent(secondsSpent);

    final int exercisesDone = users?['exercisesDone'] ?? 0;
    final int highestStreakFromUserData = users?['highestStreak'] ?? 0;

    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color.fromARGB(255, 101, 225, 247), Color.fromARGB(255, 220, 139, 234)],
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
            "${users?['name'] ?? 'User'}'s Report",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),

          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 350) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _statCard('Time Spent', timeSpent, Icons.access_time),
                    const Divider(color: Colors.white),
                    _statCard('Exercises Done', '$exercisesDone', Icons.book),
                    const Divider(color: Colors.white),
                    _statCard('Highest Streak', '$highestStreakFromUserData', Icons.emoji_events),
                  ],
                );
              }

              return IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(child: _statCard('Time Spent', timeSpent, Icons.access_time)),
                    const VerticalDivider(color: Colors.white, thickness: 1),
                    Expanded(child: _statCard('Exercises Done', '$exercisesDone', Icons.book)),
                    const VerticalDivider(color: Colors.white, thickness: 1),
                    Expanded(child: _statCard('Highest Streak', '$highestStreakFromUserData', Icons.whatshot)),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );

  }

  Widget _statCard(String title, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 30, color: Colors.white),
          const SizedBox(width: 10),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
                '$title:',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 130, 255, 88)),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

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
}
