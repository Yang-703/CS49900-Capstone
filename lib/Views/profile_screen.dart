/* lib/Views/profile_screen.dart */
import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_study_app/Views/login_screen.dart';
import 'package:flutter_study_app/Widgets/my_button.dart';
import 'package:flutter_study_app/Widgets/snackbar.dart';
import 'package:image_picker/image_picker.dart';
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

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  // Fetch user data from Firestore
  Future<void> fetchUserData() async {
    if (user == null) return;
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get();

      if (documentSnapshot.exists) {
        setState(() {
          users = documentSnapshot.data() as Map<String, dynamic>?;
          if (users?['photoBase64'] != null) {
            profileImageBytes = base64Decode(users!['photoBase64']);
          }
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        showSnackBar(context, "No user data found.");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, "Failed to fetch user data: $e");
    }
  }

  // Update the profile image in Firestore
  Future<void> updateProfileImage(Uint8List imageBytes) async {
    if (user == null) return;
    try {
      String base64Image = base64Encode(imageBytes);
      await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .set({'photoBase64': base64Image}, SetOptions(merge: true));
      setState(() {
        profileImageBytes = imageBytes;
      });
      showSnackBar(context, "Profile image updated successfully");
    } catch (e) {
      showSnackBar(context, "Failed to update profile image: $e");
    }
  }

  // Pick an image from the gallery
  Future<void> pickImageFromGallery() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage == null) return;
    final imageBytes = await pickedImage.readAsBytes();
    await updateProfileImage(imageBytes);
  }

  Future<void> signOut() async {
  // Show a confirmation dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Color.fromARGB(255, 78, 138, 207), // Match the app's background color
        title: Text(
          'Are you sure?',
          style: TextStyle(
            color: Colors.white, // Matching the text color
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        content: Text(
          'Do you really want to sign out?',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text(
              'No',
              style: TextStyle(
                color: Colors.white, // Matching the button color
                fontSize: 16,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LogInScreen()),
              );
            },
            child: const Text(
              'Yes',
              style: TextStyle(
                color: Colors.white, // Matching the button color
                fontSize: 16,
              ),
            ),
          ),
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      // Gradient background
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFE3F2FD)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : users == null
                  ? const Center(child: Text("No user data found"))
                  : Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          // Profile picture with a camera icon overlay
                          GestureDetector(
                            onTap: pickImageFromGallery,
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.blue[100],
                                  radius: 60,
                                  backgroundImage: profileImageBytes != null
                                      ? MemoryImage(profileImageBytes!)
                                      : const NetworkImage(
                                          "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png",
                                        ) as ImageProvider,
                                ),
                                CircleAvatar(
                                  backgroundColor: Colors.black,
                                  radius: 18,
                                  child: const Icon(
                                    Icons.camera_alt,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Display user's name.
                          Text(
                            users?['name'] ?? "No Name",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Display user stars in a container.
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amberAccent,
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "Stars: ${users?['stars'] ?? 0}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amberAccent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          const Divider(thickness: 1),
                          const SizedBox(height: 30),
                          // Sign Out button.
                          SizedBox(
                            width: double.infinity,
                            child: MyButton(
                              onTap: signOut,
                              buttonText: "Sign Out",
                            ),
                          ),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }
}