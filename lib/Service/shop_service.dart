/* lib/Service/shop_service.dart */
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_study_app/Models/shop_item.dart';

class ShopService {
  static final _fs = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;
  static User? get _user => _auth.currentUser;

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
    'Themes',
    'Cosmetic',
    'Boosts',
  ];

  static final List<ShopItem> _allItems = [
    ShopItem(
      id: 'theme_dark',
      name: 'Premium Dark Mode',
      description: 'Unlock sleek dark mode across the app.',
      cost: 50,
      imageUrl: 'https://img.freepik.com/free-vector/locker_53876-25496.jpg?ga=GA1.1.176898006.1745256845&semt=ais_hybrid&w=740',
      category: 'Themes',
      type: 'theme',
    ),
    ShopItem(
      id: 'frame_gold',
      name: 'Gold Avatar Frame',
      description: 'Surround your avatar with gold flair.',
      cost: 30,
      imageUrl: 'https://img.freepik.com/free-vector/locker_53876-25496.jpg?ga=GA1.1.176898006.1745256845&semt=ais_hybrid&w=740',
      category: 'Cosmetic',
      type: 'cosmetic',
    ),
    ShopItem(
      id: 'boost_life',
      name: 'Extra Life',
      description: 'One free retry on any quiz.',
      cost: 15,
      imageUrl: 'https://img.freepik.com/free-vector/locker_53876-25496.jpg?ga=GA1.1.176898006.1745256845&semt=ais_hybrid&w=740',
      category: 'Boosts',
      type: 'extra_life',
    ),
    ShopItem(
      id: 'featured_bundle',
      name: 'Starter Pack',
      description: '5 lives + exclusive theme + frame.',
      cost: 100,
      imageUrl: 'https://img.freepik.com/free-vector/locker_53876-25496.jpg?ga=GA1.1.176898006.1745256845&semt=ais_hybrid&w=740',
      category: 'Featured',
      type: 'bundle',
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
}