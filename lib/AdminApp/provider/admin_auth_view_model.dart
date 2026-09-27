import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminAuthProvider extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  bool isLoading = false;
  String error = "";

  bool visibility = true;

  void passwordVisibility() {
    visibility = !visibility;
    notifyListeners();
  }

  String? validateEmail(String email) {
    if (email.isEmpty) {
      return "Please enter email";
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegex.hasMatch(email)) {
      return "Please enter a valid email";
    }

    return null;
  }

  String? validatePassword(String password) {
    if (password.isEmpty) {
      return "Please enter password";
    }

    if (password.length < 8) {
      return "Password must be at least 8 characters";
    }

    return null;
  }

  Future<bool> login(String email, String password) async {
    try {
      isLoading = true;
      error = "";

      notifyListeners();

      final userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;

      if (user == null) {
        error = "Login failed";
        return false;
      }

      final admin = await firestore.collection("admin").doc(user.uid).get();

      if (!admin.exists) {
        await auth.signOut();

        error = "You are not an admin";
        return false;
      }

      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        error = "User not found";
      } else if (e.code == "wrong-password") {
        error = "Wrong password";
      } else if (e.code == "invalid-email") {
        error = "Invalid email";
      } else {
        error = "Login failed";
      }

      return false;
    } catch (e) {
      error = "Something went wrong";
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await auth.signOut();
  }
}
