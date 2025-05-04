/* lib/Views/inventory_screen.dart */
import 'package:flutter/material.dart';
import 'package:flutter_study_app/Service/shop_service.dart';
import 'package:flutter_study_app/Models/shop_item.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            StreamBuilder<int>(
              stream: ShopService.extraLivesStream(),
              builder: (context, livesSnap) {
                final lives = livesSnap.data ?? 0;
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.favorite, color: Colors.redAccent),
                    title: Text(
                      'Extra Lives:',
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    trailing: Text(
                      lives.toString(),
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<Set<String>>(
                stream: ShopService.inventoryStream(),
                builder: (context, snap) {
                  final ids = snap.data ?? <String>{};
                  if (ids.isEmpty) {
                    return const Center(
                      child: Text('No items purchased yet.'),
                    );
                  }
                  final items = ShopService.allItems
                      .where((item) => ids.contains(item.id))
                      .toList();
                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final ShopItem item = items[index];
                      return Card(
                        child: ListTile(
                          leading: Image.network(
                            item.imageUrl,
                            width: 40,
                            height: 40,
                            errorBuilder: (_, __, ___) => const Icon(Icons.error),
                          ),
                          title: Text(item.name),
                          subtitle: Text(item.description),
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
    );
  }
}