// field_screen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_study_app/Views/quiz_screen.dart';

class FieldCategory extends StatefulWidget {
  const FieldCategory({super.key});

  @override
  State<FieldCategory> createState() => _FieldCategoryState();
}

class _FieldCategoryState extends State<FieldCategory> {
  // Firestore collection reference for fields of study
  final CollectionReference categoriesCollection =
      FirebaseFirestore.instance.collection("questions");

  @override
  Widget build(BuildContext context) {
    // Adjust grid columns based on screen width (2 for mobile, 3 for larger screens)
    final int crossAxisCount = MediaQuery.of(context).size.width > 600 ? 3 : 2;

    return Scaffold(
      // AppBar with a title
      appBar: AppBar(
        title: const Text(
          "Explore Courses",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      // A light gradient background for a nicer look
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Color(0xFFE3F2FD), // Light blueish background
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // A heading that tells users to pick a category
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Choose a Subject or Field",
                    style: TextStyle(
                      height: 2,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // The main area that displays the categories in a grid
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: categoriesCollection.snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Text("No quiz categories available"),
                        );
                      }

                      // List of colors for category cards
                      final List<Color> cardColors = [
                        Color(0xFF6C63FF),
                        Color(0xFF00C9A7),
                        Color(0xFFB2BEC3),
                        Color(0xFF9B5DE5),
                        Color(0xFFFFA600),
                        Color(0xFFFF6B6B),
                        Color(0xFF4D96FF),
                      ];

                      return GridView.builder(
                        itemCount: snapshot.data!.docs.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                        ),
                        itemBuilder: (context, index) {
                          final DocumentSnapshot doc =
                              snapshot.data!.docs[index];
                          final String title = doc['title'] ?? 'No Title';
                          final String imageUrl = doc['image_url'] ?? '';

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      QuizScreen(categoryName: title),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              color: cardColors[index % cardColors.length],
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Display category image with error handling
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(16),
                                    ),
                                    child: Image.network(
                                      imageUrl,
                                      height: 130,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          height: 130,
                                          color: Colors.grey.shade300,
                                          child: const Center(
                                            child: Icon(Icons.error),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // Display category title
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Text(
                                      title,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        height: 1.2,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
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