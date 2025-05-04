/* lib/Widgets/shop_item_card.dart */
import 'package:flutter/material.dart';
import 'package:flutter_study_app/Models/shop_item.dart';

class ShopItemCard extends StatelessWidget {
  final ShopItem item;
  final bool owned;
  final int userCoins;
  final VoidCallback onPurchase;

  const ShopItemCard({
    super.key,
    required this.item,
    required this.owned,
    required this.userCoins,
    required this.onPurchase,
  });

  @override
  Widget build(BuildContext context) {
    final isPermanent = item.type != 'extra_life';
    final ownedPermanent = owned && isPermanent;
    final bool canBuy = userCoins >= item.cost && !ownedPermanent;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                item.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey[300],
                  child: const Center(child: Icon(Icons.broken_image)),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  item.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.monetization_on,
                                color: Colors.green, size: 20),
                            Text(
                              '${item.cost}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: ownedPermanent ? null : (canBuy ? onPurchase : null),
                      style: TextButton.styleFrom(
                      backgroundColor: ownedPermanent
                        ? Colors.blue
                        : (canBuy ? Colors.green : Colors.red),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                        minimumSize: const Size(80, 20),
                      ),
                      child: Text(
                      ownedPermanent
                        ? 'Owned'
                        : (canBuy ? 'Buy' : 'Too Expensive'),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}