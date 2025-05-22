/* lib/Models/shop_item.dart */
class ShopItem {
  final String id;
  final String name;
  final String description;
  final int cost;
  final String imageUrl;
  final String category;
  final String type;

  ShopItem({
    required this.id,
    required this.name,
    required this.description,
    required this.cost,
    required this.imageUrl,
    required this.category,
    required this.type,
  });
  
  factory ShopItem.fromMap(Map<String, dynamic> data) {
    return ShopItem(
      id: data['id'],
      name: data['name'],
      description: data['description'],
      cost: data['cost'],
      imageUrl: data['imageUrl'],
      category: data['category'],
      type: data['type'] as String,
    );
 }

 Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'cost': cost,
      'imageUrl': imageUrl,
      'category': category,
      'type': type,
    };
 }
}