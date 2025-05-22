/* lib/Views/shop_screen.dart */
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_study_app/Models/shop_item.dart';
import 'package:flutter_study_app/Service/shop_service.dart';
import 'package:flutter_study_app/Widgets/shop_item_card.dart';
import 'package:flutter_study_app/Widgets/snackbar.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
Widget build(BuildContext context) {
  return DefaultTabController(
    length: ShopService.categories.length,
    child: Scaffold(
      appBar: AppBar(
        title: const Text('Shop', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF7CB0FC),
                Color(0xFF638FDB),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        bottom: TabBar(
          isScrollable: false,
          labelColor: const Color.fromARGB(255, 252, 227, 7),
          unselectedLabelColor: Colors.white,
          tabs: ShopService.categories.map((c) {
            return Tab(text: c, icon: Icon(_iconForCategory(c)));
          }).toList(),
        ),
      ),
      backgroundColor: const Color(0xFFDDE7FD),
        body: Column(
          children: [
            StreamBuilder<int>(
              stream: ShopService.coinStream(),
              builder: (context, coinSnap) {
                if (coinSnap.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  );
                }
                final coins = coinSnap.data ?? 0;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.monetization_on, color: Colors.green, size: 28),
                      const SizedBox(width: 8),
                      Text('$coins', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                );
              },
            ),
            const Divider(height: 1),
            Expanded(
              child: TabBarView(
                children: ShopService.categories
                    .map((category) => _CategoryView(category: category))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconForCategory(String category) {
    switch (category) {
      case 'Featured':
        return Icons.pets;
      case 'Cosmetic':
        return Icons.brush;
      case 'Boosts':
        return Icons.flash_on;
      default:
        return Icons.star;
    }
  }
}

class _CategoryView extends StatelessWidget {
  final String category;
  const _CategoryView({required this.category});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ShopItem>>(
      stream: ShopService.itemsStream(category),
      builder: (context, itemSnap) {
        if (itemSnap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final items = itemSnap.data ?? [];
        if (items.isEmpty) {
          return Center(
            child: Text(
              'No items in $category',
              style: const TextStyle(color: Colors.grey),
            ),
          );
        }

        return StreamBuilder<Set<String>>(
          stream: ShopService.inventoryStream(),
          builder: (context, invSnap) {
            if (invSnap.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final owned = invSnap.data ?? {};

            return StreamBuilder<int>(
              stream: ShopService.coinStream(),
              builder: (context, coinSnap) {
                if (coinSnap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final coins = coinSnap.data ?? 0;

                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, idx) {
                      final it = items[idx];
                      return ShopItemCard(
                        item: it,
                        owned: owned.contains(it.id),
                        userCoins: coins,
                        onPurchase: () async {
                          try {
                            await ShopService.purchaseItem(it);
                            showDialog(
                              context: context,
                              builder: (dialogContext) => Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Lottie.network(
                                          'https://assets9.lottiefiles.com/packages/lf20_touohxv0.json',
                                          height: 100),
                                      const SizedBox(height: 12),
                                      const Text(
                                        'Purchase Successful!',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 12),
                                      ElevatedButton(
                                        onPressed: () => Navigator.of(dialogContext).pop(),
                                        child: const Text('Great!'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } catch (e) {
                            showSnackBar(
                              context,
                              e.toString().replaceAll(
                                  'Exception: ', ''));
                          }
                        },
                      );
                    },
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}