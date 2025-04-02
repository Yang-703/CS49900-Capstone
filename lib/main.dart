import 'package:cs499/courses.dart';
import 'package:cs499/profile.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'calendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Study App',
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int page_Index = 0;
  String user = "User";
  
  String getUser(){
    return user;
  }

  void navBarOnTap(int index){
    setState(() {
      page_Index = index;
    });
  }

  void toProfile(){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const profilePage()));
  }
  
  static const List<Widget> _pages = <Widget>[
      HomePage(),
      CoursesPage(),
      CalendarPage(),
      Icon(Icons.shop),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: toProfile, icon: Icon(Icons.person, size:30),),
        ],
      ),
      drawer: Drawer(
        width: 250,
        child: ListView(
          padding: EdgeInsets.all(0),
          children: [
            SizedBox(
              height: 70,
              child:DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(""),
              )
            ),
            ListTile(
              title: Text("Settings"),
            ),
            ListTile(
              title: Text("Contact Us"),
            ),
          ],
        )
      ),
      bottomNavigationBar: BottomNavigationBar(items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.book), label:"Courses"),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: "Calendar"),
        BottomNavigationBarItem(icon: Icon(Icons.shop), label: "Shop"),
      ],
      unselectedItemColor: const Color.fromARGB(255, 121, 121, 121),
      selectedItemColor: Colors.black,
      currentIndex: page_Index,
      onTap: navBarOnTap,
      backgroundColor: Colors.black,
      ),
      body: Center(
          child:_pages.elementAt(page_Index),
      ),
    );
  }
}
