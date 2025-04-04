// auth_service.dart
import 'dart:convert';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Signs up a new user with the provided [email], [password], and [name].
  /// Optionally accepts a [profileImage] as bytes.
  /// Returns "User created successfully" on success or a descriptive error message.
  Future<String> signUpUser({
    required String email,
    required String password,
    required String name,
    Uint8List? profileImage,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty && password.isNotEmpty && name.isNotEmpty) {
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Convert profile image to base64 if provided.
        String? base64Image =
            profileImage != null ? base64Encode(profileImage) : null;

        // Storing the user data in Firestore with standardized field names.
        await _firestore.collection("users").doc(credential.user!.uid).set({
          'name': name,
          'email': email,
          'uid': credential.user!.uid,
          'stars': 0, // standardized to lowercase.
          'photoBase64': base64Image,
        });

        res = "User created successfully";
      } else {
        res = "Please fill all the fields";
      }
    } on FirebaseAuthException catch (e) {
      res = e.message ?? "An error occurred during sign up";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  /// Logs in a user with the provided [email] and [password].
  /// Returns "Login successful" on success or a descriptive error message.
  Future<String> logInUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "Login successful";
      } else {
        res = "Please fill all the fields";
      }
    } on FirebaseAuthException catch (e) {
      res = e.message ?? "An error occurred during login";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}