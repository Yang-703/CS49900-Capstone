/* lib/Views/course_screen.dart */
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_study_app/Views/course_detail_screen.dart';
import 'package:auto_size_text/auto_size_text.dart';

class CourseScreen extends StatelessWidget {
  final String fieldName;
  
  const CourseScreen({super.key, required this.fieldName});
  
  @override
  Widget build(BuildContext context) {
    CollectionReference fieldsCollection =
        FirebaseFirestore.instance.collection('questions');
    
    return Scaffold(
      appBar: AppBar(
        title: Text('$fieldName Courses'),
        backgroundColor: Colors.blueAccent,
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
          
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              itemCount: courseNames.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
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
                        // Course image
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16)),
                          child: Image.network(
                            courseImageUrl,
                            height: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 100,
                                color: Colors.grey.shade300,
                                child: const Icon(Icons.error),
                              );
                            },
                          ),
                        ),
                        // Course name
                        Expanded(
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
                                minFontSize: 12,  // Adjust as needed
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
