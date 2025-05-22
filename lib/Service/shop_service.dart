/* lib/Service/shop_service.dart */
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_study_app/Models/shop_item.dart';

class ShopService {
  static final _fs = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;
  static User? get _user => _auth.currentUser;
  static List<ShopItem> get allItems => _allItems;

  static Stream<int> coinStream() {
    if (_user == null) return Stream.value(0);
    return _fs
        .collection('users')
        .doc(_user!.uid)
        .snapshots()
        .map((snap) => snap.data()?['coins'] ?? 0);
  }

  static const List<String> categories = [
    'Featured',
    'Cosmetic',
    'Boosts',
  ];

  static final List<ShopItem> _allItems = [
    ShopItem(
      id: 'pet_puppy',
      name: 'Puppy',
      description: 'Adopt a playful puppy to keep you company!',
      cost: 50,
      imageUrl: 'https://img.freepik.com/free-psd/cute-dog-isolated_23-2150424132.jpg?ga=GA1.1.560117784.1747062533&semt=ais_hybrid&w=740',
      category: 'Featured',
      type: 'pet',
    ),
    ShopItem(
      id: 'pet_cat',
      name: 'Cat',
      description: 'Adopt a playful cat to keep you company!',
      cost: 50,
      imageUrl: 'https://img.freepik.com/free-psd/kawaii-cat-illustration_23-2151299390.jpg?ga=GA1.1.560117784.1747062533&semt=ais_hybrid&w=740',
      category: 'Featured',
      type: 'pet',
    ),
    ShopItem(
      id: 'frame_gold',
      name: 'Gold Avatar Frame',
      description: 'Surround your avatar with gold flair.',
      cost: 15,
      imageUrl: 'https://img.freepik.com/free-vector/realistic-golden-frame_23-2149233571.jpg?ga=GA1.1.1590422758.1747678019&semt=ais_hybrid&w=740',
      category: 'Cosmetic',
      type: 'cosmetic',
    ),
    ShopItem(
      id: 'boost_life',
      name: 'Extra Life',
      description: 'One free retry on any quiz.',
      cost: 5,
      imageUrl: 'https://img.freepik.com/free-vector/heart_78370-492.jpg?ga=GA1.1.1590422758.1747678019&semt=ais_hybrid&w=740',
      category: 'Boosts',
      type: 'extra_life',
    ),
  ];

  static Stream<int> extraLivesStream() {
    if (_user == null) return Stream.value(0);
    return _fs
      .collection('users')
      .doc(_user!.uid)
      .snapshots()
      .map((snap) => snap.data()?['extraLives'] ?? 0);
  }

  static Stream<List<ShopItem>> itemsStream(String category) {
    final filtered = _allItems
        .where((it) => category == 'Featured'
            ? it.category == 'Featured'
            : it.category == category)
        .toList();
    return Stream.value(filtered);
  }

  static Stream<Set<String>> inventoryStream() {
    if (_user == null) return const Stream.empty();
    return _fs
        .collection('users')
        .doc(_user!.uid)
        .collection('inventory')
        .snapshots()
        .map((snap) => snap.docs.map((d) => d.id).toSet());
  }

  static Future<void> purchaseItem(ShopItem item) async {
    if (_user == null) return;
    final userRef = _fs.collection('users').doc(_user!.uid);

    await _fs.runTransaction((tx) async {
      final snap = await tx.get(userRef);
      if (!snap.exists) throw Exception('User not found');
      final coins = snap.data()?['coins'] ?? 0;
      if (coins < item.cost) throw Exception('Insufficient coins');
      tx.update(userRef, {
        'coins': coins - item.cost,
        if (item.type == 'extra_life') 'extraLives': FieldValue.increment(1),
        if (item.type == 'theme')         'theme':        item.id,
      });
      if (item.type != 'extra_life') {
        final invRef = userRef.collection('inventory').doc(item.id);
        tx.set(invRef, {'purchasedAt': FieldValue.serverTimestamp()});
      }
    });
  }

  static Future<void> consumeExtraLife() async {
    if (_user == null) return;
    final userRef = _fs.collection('users').doc(_user!.uid);
    await userRef.update({'extraLives': FieldValue.increment(-1)});
  }

  static Future<void> selectPet(String? petId) async {
    if (_user == null) return;
    await _fs
      .collection('users')
      .doc(_user!.uid)
      .set({'selectedPet': petId}, SetOptions(merge: true));
  }

  static Stream<String?> selectedPetStream() {
    if (_user == null) return Stream.value(null);
    return _fs
      .collection('users')
      .doc(_user!.uid)
      .snapshots()
      .map((snap) => snap.data()?['selectedPet'] as String?);
  }
}