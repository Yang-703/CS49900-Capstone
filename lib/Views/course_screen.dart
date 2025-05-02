/* lib/Views/course_screen.dart */
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'course_detail_screen.dart';

class CourseScreen extends StatelessWidget {
  final String fieldName;

  const CourseScreen({super.key, required this.fieldName});

  // Helper to set number of columns based on device width
  int getCrossAxisCount(double width) {
    if (width < 600) return 1; // Phones
    if (width < 1024) return 2; // Tablets
    return 3; // Larger screens
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference fieldsCollection =
        FirebaseFirestore.instance.collection('questions');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$fieldName Courses',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: fieldsCollection.doc(fieldName).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text("No data available for $fieldName"));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          if (data["courses"] == null) {
            return Center(child: Text("No courses available for $fieldName"));
          }

          final Map<String, dynamic> courses =
              Map<String, dynamic>.from(data["courses"]);
          final List<String> courseNames = courses.keys.toList();
          final screenWidth = MediaQuery.of(context).size.width;

          return Padding(
            padding: const EdgeInsets.all(14.0),
            child: GridView.builder(
              itemCount: courseNames.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: getCrossAxisCount(screenWidth),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 3 / 2, // Adjust for card proportion
              ),
              itemBuilder: (context, index) {
                final String courseName = courseNames[index];
                final Map<String, dynamic> courseData =
                    Map<String, dynamic>.from(courses[courseName]);
                // Retrieve the image URL for the course, or use a default placeholder.
                final String courseImageUrl =
                    courseData["image_url"] ?? "https://via.placeholder.com/150";

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CourseDetailScreen(
                          fieldName: fieldName,
                          courseName: courseName,
                          courseData: courseData,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          flex: 2, // Image takes 2/3 of space
                          // Course image
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                            child: Image.network(
                              courseImageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey.shade300,
                                  child: const Icon(Icons.error),
                                );
                              },
                            ),
                          ),
                        ),
                        // Course name
                        Expanded(
                          flex: 1, // Text takes 1/3 of space
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AutoSizeText(
                                courseName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent,
                                ),
                                maxLines: 3,
                                minFontSize: 12,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}