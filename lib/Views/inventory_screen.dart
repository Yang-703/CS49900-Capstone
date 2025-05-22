/* lib/Views/inventory_screen.dart */
import 'package:flutter/material.dart';
import 'package:flutter_study_app/Service/shop_service.dart';
import 'package:flutter_study_app/Widgets/extra_lives_widget.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ShopService shopService = ShopService();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const ExtraLivesWidget(),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<Set<String>>(
                stream: shopService.inventoryStream(),
                builder: (context, invSnap) {
                  final ids = invSnap.data ?? <String>{};
                  if (ids.isEmpty) {
                    return StreamBuilder<int>(
                      stream: shopService.extraLivesStream(),
                      builder: (context, livesSnap) {
                        final lives = livesSnap.data ?? 0;
                        if (lives == 0) {
                          return const Center(
                            child: Text('No items purchased yet.'),
                          );
                      }
                        return const SizedBox.shrink();
                      },
                    );
                  }
                  final items = shopService.allItems
                      .where((item) => ids.contains(item.id))
                      .toList();
                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, i) {
                      final item = items[i];
                      return Card(
                        child: ListTile(
                          leading: Image.network(
                            item.imageUrl,
                            width: 40,
                            height: 40,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.error),
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