/* test/auth_service_test.dart */
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_study_app/Service/auth_service.dart';

void main() {
  late MockFirebaseAuth mockAuth;
  late FakeFirebaseFirestore mockFirestore;
  late AuthService service;

  setUp(() {
    mockAuth = MockFirebaseAuth();
    mockFirestore = FakeFirebaseFirestore();
    service = AuthService(auth: mockAuth, firestore: mockFirestore);
  });

  group('signUpUser', () {
    test('creates a new user and writes to Firestore', () async {
      const email = 'test@example.com';
      const password = 'password123';
      const name = 'Test User';

      final res = await service.signUpUser(
        email: email,
        password: password,
        name: name,
        profileImage: null,
      );

      expect(res, 'User created successfully');

      final user = mockAuth.currentUser!;
      final doc = await mockFirestore
          .collection('users')
          .doc(user.uid)
          .get();

      expect(doc.exists, isTrue);
      final data = doc.data()!;
      expect(data['email'], email);
      expect(data['name'], name);
      expect(data['stars'], 0);
      expect(data['coins'], 0);
      expect(data['extraLives'], 0);
    });

    test('returns error when fields are empty', () async {
      final res = await service.signUpUser(
        email: '',
        password: '',
        name: '',
        profileImage: null,
      );
      expect(res, 'Please fill all the fields');
    });
  });

  group('logInUser', () {
    test('logs in existing user', () async {
      await mockAuth.createUserWithEmailAndPassword(
          email: 'foo@bar.com', password: 'secret');
      final res = await service.logInUser(
        email: 'foo@bar.com',
        password: 'secret',
      );
      expect(res, 'Login successful');
    });

    test('returns error when missing credentials', () async {
      final res = await service.logInUser(
        email: '',
        password: '',
      );
      expect(res, 'Please fill all the fields');
    });
  });
}