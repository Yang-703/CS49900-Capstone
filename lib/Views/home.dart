import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_study_app/Widgets/snackbar.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

import 'package:flutter_study_app/Views/login_screen.dart';
import 'package:flutter_study_app/Views/contact.dart'; 
import 'package:flutter_study_app/Views/settings.dart'; 

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  final User? user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? userData;
  bool isLoading = true;
  String? userName;
  Uint8List? profileImageBytes;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    if (user == null) return;
    try {
      DocumentSnapshot documentSnapshot =
          await FirebaseFirestore.instance
              .collection("users")
              .doc(user!.uid)
              .get();

      if (documentSnapshot.exists) {
        setState(() {
          if (!mounted) return; /////////////////////////////
          userData = documentSnapshot.data() as Map<String, dynamic>?;
          if (userData?['photoBase64'] != null) {
            profileImageBytes = base64Decode(userData!['photoBase64']);
          }
          isLoading = false;
        });
      } else {
        if (!mounted) return; /////////////////////////////////////
        setState(() {
          isLoading = false;
        });
        showSnackBar(context, "No user data found.");
      }
    } catch (e) {
      if (!mounted) return; /////////////////////////////
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, "Failed to fetch user data: $e");
    }
  }

  ////////////////////////////////////////////////////////////////////
  // Show confirmation dialog before sign out
  Future<void> signOut() async {
  // Show a confirmation dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Color.fromARGB(255, 65, 133, 211), // Match the app's background color
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
  ////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext build) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: const Text(
          "Home",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        ///////////////////////////////////////
        leading: Builder( 
          builder: (context) => IconButton(
            icon: const Padding(
              padding: EdgeInsets.only(left:12.0),
              child: Icon(
                Icons.menu, 
                color: Colors.white, 
              ),
            ), 
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },  
          ),
        ),
        ///////////////////////////////////////
      ),
      ///////////////////////////////////////
      drawer: Drawer(
        backgroundColor: Color.fromARGB(255, 78, 138, 207), // Match background with nav bar
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 120.0),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.settings,
                      color: Colors.white, // Match nav bar icon color
                    ),
                    title: Text(
                      'Settings',
                      style: TextStyle(color: Colors.white), // Match nav bar text color
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SettingsPage()),
                      );
                    }
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.info,
                      color: Colors.white, // Match nav bar icon color
                    ),
                    title: Text(
                      'Contact Us',
                      style: TextStyle(color: Colors.white), // Match nav bar text color
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ContactPage()),
                      );
                    }
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, bottom: 25),
              child: ListTile(
                leading: Icon(
                  Icons.logout,
                  color: Colors.white, // Match nav bar icon color
                ),
                title: Text(
                  'Sign Out',
                  style: TextStyle(color: Colors.white), // Match nav bar text color
                ),
                onTap: signOut, // Sign out on tap with confirmation
              ),
            ),
          ],
        ),
      ),
      extendBody: true,
      ///////////////////////////////////////
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20,),
          Align(
            alignment: Alignment(0,2),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 110, 110, 110),
                    spreadRadius: 2,
                    blurRadius: 2,
                    offset: Offset(5,5),
                  ),
                ],
                gradient: RadialGradient(
                  colors: <Color>[
                    const Color.fromARGB(255, 139, 218, 255),
                    const Color.fromARGB(255, 132, 154, 255),
                  ],
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Welcome ${userData?['name']}',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Image.asset(
                      'assets/mascot.png',
                      fit: BoxFit.scaleDown,
                      height: 200,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 50,),
          Text('In Progress', style: TextStyle(fontSize:20,fontWeight: FontWeight.bold),),
          DecoratedBox(decoration: BoxDecoration(color: Colors.blue),
          child:FlutterCarousel(items: [Placeholder()], 
          options: FlutterCarouselOptions(enableInfiniteScroll: true, height: 200, enlargeCenterPage: true)),
          )
        ],
      ),
    );
  }
}