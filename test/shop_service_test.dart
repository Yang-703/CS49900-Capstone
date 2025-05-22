/* test/shop_service_test.dart */
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_study_app/Service/shop_service.dart';

void main() {
  group('ShopService', () {
    late FakeFirebaseFirestore fs;
    late MockFirebaseAuth auth;
    late ShopService service;

    setUp(() async {
      fs = FakeFirebaseFirestore();
      auth = MockFirebaseAuth(
        signedIn: true,
        mockUser: MockUser(uid: 'uid123'),
      );

      await fs.collection('users').doc('uid123').set({
        'coins': 100,
        'extraLives': 0,
      });

      service = ShopService(firestore: fs, auth: auth);
    });

    test('coinStream & extraLivesStream emit seeded values', () async {
      final coins = await service.coinStream().first;
      final lives = await service.extraLivesStream().first;

      expect(coins, 100);
      expect(lives, 0);
    });

    test('itemsStream filters by category', () async {
      final featured = await service.itemsStream('Featured').first;
      final cosmetic = await service.itemsStream('Cosmetic').first;
      final boosts   = await service.itemsStream('Boosts').first;

      expect(featured.length, 2);
      expect(cosmetic.length, 1);
      expect(boosts.length, 1);
    });

    test('purchaseItem for a cosmetic decrements coins & adds inventory doc', () async {
      final item = service.allItems.firstWhere((i) => i.type == 'cosmetic');
      await service.purchaseItem(item);

      final userDoc = await fs.collection('users').doc('uid123').get();
      expect(userDoc.data()!['coins'], 100 - item.cost);

      final invDoc = await fs
          .collection('users')
          .doc('uid123')
          .collection('inventory')
          .doc(item.id)
          .get();
      expect(invDoc.exists, isTrue);
    });

    test('purchaseItem for an extra_life increments extraLives only', () async {
      final item = service.allItems.firstWhere((i) => i.type == 'extra_life');
      await service.purchaseItem(item);

      final userDoc = await fs.collection('users').doc('uid123').get();
      expect(userDoc.data()!['coins'], 100 - item.cost);
      expect(userDoc.data()!['extraLives'], 1);

      final invDoc = await fs
          .collection('users')
          .doc('uid123')
          .collection('inventory')
          .doc(item.id)
          .get();
      expect(invDoc.exists, isFalse);
    });

    test('purchaseItem throws on insufficient coins', () async {
      await fs.collection('users').doc('uid123').set({
        'coins': 5,
        'extraLives': 0,
      });
      final item = service.allItems.first;

      expect(
        () => service.purchaseItem(item),
        throwsA(isA<Exception>().having((e) => e.toString(), 'msg', contains('Insufficient coins'))),
      );
    });

    test('selectPet and selectedPetStream', () async {
      expect(await service.selectedPetStream().first, isNull);
      final petId = service.allItems.first.id;
      await service.selectPet(petId);
      expect(await service.selectedPetStream().first, petId);
      await service.selectPet(null);
      expect(await service.selectedPetStream().first, isNull);
    });
  });
}