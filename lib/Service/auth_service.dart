/* lib/Service/auth_service.dart */
import 'dart:convert';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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

        String? base64Image = profileImage != null ? base64Encode(profileImage) : null;

        await _firestore.collection("users").doc(credential.user!.uid).set({
          'name': name,
          'email': email,
          'uid': credential.user!.uid,
          'stars': 0,
          'coins': 0,
          'extraLives': 0,
          'photoBase64': base64Image,
          'timeSpent' : 0,
          'exercisesDone' : 0, 
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

  Future<String> resetPassword({ required String email }) async {
    try {
      if (email.trim().isEmpty) {
        return "Please enter your email";
      }
      await _auth.sendPasswordResetEmail(email: email.trim());
      return "A reset link has been sent to your email.";
    } on FirebaseAuthException catch (e) {
      return e.message ?? "An unexpected error occurred";
    } catch (e) {
      return e.toString();
    }
  }
}