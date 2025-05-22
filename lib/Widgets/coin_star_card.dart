/* lib/Widgets/coin_star_card.dart */
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_study_app/Service/shop_service.dart';

class UserStatusCard extends StatelessWidget {
  const UserStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    final ShopService shopService = ShopService();
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF4A90E2), Color(0xFF50E3C2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          StreamBuilder<int>(
            stream: shopService.coinStream(),
            builder: (context, snapshot) {
              final coins = snapshot.data ?? 0;
              return Row(
                children: [
                  const Icon(Icons.monetization_on, size: 28, color: Colors.greenAccent),
                  const SizedBox(width: 6),
                  Text(
                    coins.toString(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              );
            },
          ),

          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .snapshots(),
            builder: (context, snapshot) {
              final stars = snapshot.data?.data()?['stars'] as int? ?? 0;
              return Row(
                children: [
                  const Icon(Icons.star, size: 28, color: Colors.yellow),
                  const SizedBox(width: 6),
                  Text(
                    stars.toString(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}