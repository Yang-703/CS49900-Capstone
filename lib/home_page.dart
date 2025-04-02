import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';


class HomePage extends StatefulWidget{
  const HomePage({super.key});
  
  @override
  State<StatefulWidget> createState() => _HomePage();
}

class _HomePage extends State<HomePage>{
  String user = "user";

  String getUser(){
    return "";
  }
  
  @override
  Widget build(BuildContext context){
    return Padding(
      padding:EdgeInsetsDirectional.only(top:10),
      child:Column(
        children: [
          Text('Welcome $user', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
          Image(image:AssetImage('assets/home/mascot.png'),fit:BoxFit.scaleDown),
          SizedBox(height: 30),
          InProgressCourses(),
        ],
      )
    );
  }
}

class InProgressCourses extends StatefulWidget{
  const InProgressCourses({super.key});

   @override
  State<InProgressCourses> createState() => _Progress();
}

class _Progress extends State<InProgressCourses>{
  @override
  Widget build(BuildContext context){
    return Container(
      color:const Color.fromARGB(255, 76, 88, 255),
      child: Column(children: [
        Text("In Progress", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
        FlutterCarousel(
            items: [
              Placeholder(),
              Placeholder(),
            ], 
            options: FlutterCarouselOptions(
              enlargeCenterPage: true,
              enableInfiniteScroll: true,
              height: 200,
            ),
          ),
        SizedBox(height: 20),
      ],)
    );
  }
  
}