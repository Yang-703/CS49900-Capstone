/* lib/Views/leaderboard.dart */
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class Leaderboard extends StatelessWidget {
  const Leaderboard({super.key});
  
  Stream<List<Map<String, dynamic>>> getLeaderboardData() {
    return FirebaseFirestore.instance
      .collection('users')
      .orderBy('stars', descending: true)
      .snapshots()
      .map(
        (snapshot) => snapshot.docs.map((doc) {
          final data = doc.data();
          data['uid'] = doc.id;  
          return data;
        }).toList()
      );
  }

  String getShortName(String name) {
    return name.length > 7 ? name.substring(0, 7) : name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: StreamBuilder(
        stream: getLeaderboardData(),
        builder:(context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final users = snapshot.data!;
          if(users.isEmpty){
            return const Center(
              child: Text("No users found!"),
            );
          }
          final topThree = users.take(3).toList();
          final remainingUser = users.skip(3).toList();
          return Column(
            children: [
              Stack(
                children: [
                  Image.asset(
                    "assets/leaderboard.jpg",
                    width: double.maxFinite,
                    height: 510,
                    alignment: Alignment.bottomCenter,
                    fit: BoxFit.cover,
                  ),
                  const Positioned(
                    top: 60,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text(
                      "Leaderboard",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      ),
                    ),
                  ),
                  if (topThree.isNotEmpty)
                    Positioned(
                      top: 115,
                      right: 50,
                      left: 50,
                      child: _buildTopUser(topThree[0], 1, context),
                    ),
                  if (topThree.length >= 2)
                    Positioned(
                      top: 212,
                      left: 31,
                      child: _buildTopUser(topThree[2], 3, context),
                    ),
                  if (topThree.length >= 3)
                    Positioned(
                      top: 190,
                      right: 29,
                      child: _buildTopUser(topThree[1], 2, context),
                    ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: remainingUser.length,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    final user = remainingUser[index];
                    final rank = index + 4;
                    return _buildOtherUser(user, rank, context);
                  },
                ),
              ),
            ],
          );
        }
      ),
    );
  }

  Widget _buildTopUser(Map<String, dynamic> user, int rank, BuildContext context) {
    final String uid = user['uid'] as String;
    final inventoryStream = FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('inventory')
      .snapshots()
      .map((snap) => snap.docs.map((d) => d.id).toSet());
    return StreamBuilder<Set<String>>(
      stream: inventoryStream,
      builder: (ctx, invSnap) {
        final bool hasFrame = invSnap.data?.contains('frame_gold') ?? false;
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: [
              Container(
                padding: hasFrame ? const EdgeInsets.all(0) : EdgeInsets.zero,
                decoration: hasFrame
                  ? BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.amber, width: 5),
                    )
                  : null,
                child: CircleAvatar(
                  radius: rank == 1 ? 40 : 30,
                  backgroundColor: const Color.fromARGB(255, 123, 123, 123),
                  backgroundImage: user['photoBase64'] != null
                    ? MemoryImage(
                        base64Decode(user['photoBase64']),
                      )
                    : null,
                  child: user['photoBase64'] == null
                    ? Icon(
                        Icons.person,
                        size: rank == 1 ? 60 : 40,
                        color: Colors.yellow,
                      )
                    : null
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: rank == 1
                  ? Text(
                      user['name'],
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  : Text(
                      getShortName(user['name']),
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    )
              ),
              const SizedBox(height: 5),
              Container(
                height: 25,
                width: 90,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 66, 65, 65),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.yellowAccent,
                      size: 20,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "${user['stars']}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.yellowAccent,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOtherUser(Map<String, dynamic> user, int rank, BuildContext context) {
    final String uid = user['uid'] as String;

    final inventoryStream = FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('inventory')
      .snapshots()
      .map((snap) => snap.docs.map((d) => d.id).toSet());
    return StreamBuilder<Set<String>>(
      stream: inventoryStream,
      builder: (ctx, invSnap) {
        final bool hasFrame = invSnap.data?.contains('frame_gold') ?? false;
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          elevation: 2,
          color: const Color.fromARGB(255, 138, 131, 134),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            child: Row(
              children: [
                Text(
                  '$rank',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: hasFrame ? 12 : 18),
                Container(
                  padding: hasFrame ? const EdgeInsets.all(0) : EdgeInsets.zero,
                  decoration: hasFrame
                  ? BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.amber, width: 5),
                    )
                  : null,
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: const Color.fromARGB(0, 255, 255, 255),
                    backgroundImage: user['photoBase64'] != null
                        ? MemoryImage(base64Decode(user['photoBase64']))
                        : null,
                    child: user['photoBase64'] == null
                        ? const Icon(
                            Icons.person,
                            size: 30,
                            color: Colors.yellow,
                          )
                        : null,
                  ),
                ),
                SizedBox(width: hasFrame ? 12 : 17),
                Expanded(
                  child: Text(
                    user['name'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  height: 30,
                  width: 90,
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.yellowAccent,
                        size: 20,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "${user['stars']}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.yellowAccent,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}