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
        title: const Text('Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFE3F2FD)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : users == null
                ? const Center(child: Text('No user data found'))
                : Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: pickImageFromGallery,
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.blue[100],
                                backgroundImage: profileImageBytes != null
                                    ? MemoryImage(profileImageBytes!)
                                    : const NetworkImage(
                                            'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png')
                                        as ImageProvider,
                              ),
                              const CircleAvatar(
                                radius: 18,
                                backgroundColor: Colors.black,
                                child: Icon(Icons.camera_alt,
                                    size: 20, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        Text(
                          users?['name'] ?? 'No Name',
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent),
                        ),
                        const SizedBox(height: 10),

                        _statChip(
                          icon: Icons.star,
                          color: Colors.yellowAccent,
                          label: 'Stars',
                          value: users?['stars'] ?? 0,
                        ),
                        const SizedBox(height: 10),

                        _statChip(
                          icon: Icons.monetization_on,
                          color: Colors.greenAccent,
                          label: 'Coins',
                          value: users?['coins'] ?? 0,
                        ),
                        const SizedBox(height: 10),

                        _statChip(
                          icon: Icons.local_fire_department,
                          color: Colors.orangeAccent,
                          label: 'Current Streak',
                          value: currentStreak,
                          suffix: currentStreak == 1 ? ' day' : ' days',
                        ),
                        const SizedBox(height: 10),

                        _statChip(
                          icon: Icons.emoji_events,
                          color: const Color.fromARGB(255, 237, 157, 251),
                          label: 'Highest Streak',
                          value: highestStreak,
                          suffix: highestStreak == 1 ? ' day' : ' days',
                        ),
                        const SizedBox(height: 30),

                        const Divider(thickness: 1),
                        const SizedBox(height: 30),

                        SizedBox(
                          width: double.infinity,
                          child: MyButton(
                            onTap: signOut,
                            buttonText: 'Sign Out',
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget _statChip({
    required IconData icon,
    required String label,
    required int value,
    Color? color,
    String suffix = '',
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color ?? Colors.white, size: 24),
          const SizedBox(width: 8),
          Text(
            '$label: $value$suffix',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: color ?? Colors.white),
          ),
        ],
      ),
    );
  }
}