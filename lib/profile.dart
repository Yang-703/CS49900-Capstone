import 'package:flutter/material.dart';

class profilePage extends StatefulWidget {
  const profilePage({super.key});

  @override
  State<profilePage> createState() => _profile();
}
class _profile extends State<profilePage> {

  late TextEditingController userNameController;
  String getUser(){
    return "";
  }
  String user = "User";

  @override
  void initState() {
    super.initState();
    userNameController = TextEditingController();
  }

  @override
  void dispose() {
    userNameController.dispose();
    super.dispose();
  }

  void enterNewUser() {
    if (userNameController.text == '') return;
    setState(() {
      user = userNameController.text;
    });
    Navigator.of(context).pop(userNameController);
    userNameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.values.first,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.person, size: 150),
            GestureDetector(
              onTap: () => openChangeUser(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(user, style: TextStyle(fontSize: 30)),
                  Icon(Icons.edit),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future openChangeUser() => showDialog(
    //function that creates the pop up to change userName
    context: context,
    builder:
        (context) => AlertDialog(
          title: Text("Change Username"),
          content: TextField(
            autofocus: true,
            decoration: InputDecoration(hintText: "Enter New Username"),
            controller: userNameController,
            onSubmitted: (e) => enterNewUser(),
          ),
          actions: [TextButton(onPressed: enterNewUser, child: Text("Enter"))],
        ),
  );
}
