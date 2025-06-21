import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseAuthProvider with ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign Up
  Future<bool> signUpWithEmailandPassword(
      String email, String password, String name) async {
    _loading = true;
    notifyListeners();
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        userCredential.user!.updateDisplayName(name);
        return true;
      }
      return userCredential.user != null ? true : false;
    } catch (e) {
      print("Sign Up Error: $e");
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // Sign In
  Future<bool> signInWithEmailandPassword(String email, String password) async {
    _loading = true;
    notifyListeners();
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        return true;
      }
      return false;
    } catch (e) {
      print("Login Error: $e");
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
