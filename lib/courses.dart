import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<StatefulWidget> createState() => _CoursesPage();
}

class _CoursesPage extends State<CoursesPage> {
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Text(
            "Courses",
            style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
          ),
        ),
        Divider(thickness: 5),

        Align(
          alignment: Alignment(-0.8, 0),
          child: Text(
            "Math",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 0, 181, 253),
            borderRadius: BorderRadius.circular(15),
          ),
          child: FlutterCarousel(
            items: [
              TextButton(
                onPressed: () {},
                child: Image(
                  image: AssetImage("assets/courses/math.png"),
                  width: 150,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Image(
                  image: AssetImage("assets/courses/shapes.png"),
                  width: 150,
                ),
              ),
            ],
            options: FlutterCarouselOptions(
              enlargeCenterPage: true,
              enableInfiniteScroll: true,
              height: 200,
            ),
          ),
        ),
        SizedBox(height: 30),
        Divider(height: 10),

        Align(
          alignment: Alignment(-0.8, 0),
          child: Text(
            "English",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 116, 255, 158),
            borderRadius: BorderRadius.circular(15),
          ),
          child: FlutterCarousel(
            items: [
              TextButton(
                onPressed: () {},
                child: Image(
                  image: AssetImage("assets/courses/abc.png"),
                  width: 150,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Image(
                  image: AssetImage("assets/courses/book.png"),
                  width: 150,
                ),
              ),
            ],
            options: FlutterCarouselOptions(
              enlargeCenterPage: true,
              enableInfiniteScroll: true,
              height: 200,
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}

//creates the courses from database
class Courses extends StatefulWidget{
  final int courseId;
  const Courses({super.key, required this.courseId});

  @override
  State<StatefulWidget> createState() => _Courses();
}

class _Courses extends State<Courses>{
  String getCourseName(){
    return "";
  }
  
  @override
  Widget build(BuildContext context) {
    int _courseID = widget.courseId;
    return Container();
  }
}