/* lib/Models/shop_item.dart */
class ShopItem {
  final String id;
  final String name;
  final String description;
  final int cost;
  final String imageUrl;
  final String category;

  ShopItem({
    required this.id,
    required this.name,
    required this.description,
    required this.cost,
    required this.imageUrl,
    required this.category,
  });
}