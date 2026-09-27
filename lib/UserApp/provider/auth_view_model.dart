import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shop_easy/UserApp/UI/Screens/AuthScreens/login_screen.dart';
import 'package:shop_easy/UserApp/UI/Screens/MainScreen/main_screen.dart';
import 'package:shop_easy/UserApp/model/userModel/user_model.dart';
import 'package:shop_easy/UserApp/utills/show_msg.dart';
import 'package:shop_easy/main.dart';

class AuthViewModel extends ChangeNotifier {
  bool isLoading = false;
  bool googleLoading = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;

  final name = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool visibility = true;
  bool confirmVisibility = true;
  void passwordVisibility() {
    visibility = !visibility;
    notifyListeners();
  }
   void confirmPasswordVisibility (){
    confirmVisibility = !confirmVisibility;
    notifyListeners();
   }

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter your name";
    }

    if (value.trim().length < 3) {
      return "Name must be at least 3 characters";
    }

    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter your email";
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegex.hasMatch(value.trim())) {
      return "Please enter a valid email";
    }

    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter your phone number";
    }

    final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');

    if (!phoneRegex.hasMatch(value.trim())) {
      return "Please enter a valid phone number";
    }

    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your password";
    }

    if (value.length < 6) {
      return "Password must be at least 6 characters";
    }

    return null;
  }

  String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return "Please confirm your password";
    }

    if (value != password) {
      return "Passwords do not match";
    }

    return null;
  }

  void continueWithGoogle() async {
    String webClientId = "144465602378-mli7pp6evna1j1os17h4pqm47egbvbfa.apps.googleusercontent.com";
    try {
      googleLoading = true;
      notifyListeners();
      GoogleSignIn signIn = GoogleSignIn.instance;
      await signIn.initialize(serverClientId: webClientId);
      GoogleSignInAccount account = await signIn.authenticate();
      GoogleSignInAuthentication googleAuth = account.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      await auth.signInWithCredential(credential);
      Navigator.pushAndRemoveUntil(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (context) => MainScreen()),
        (value) => false,
      );
    } catch (e) {
      showMsg(e.toString());
    } finally {
      googleLoading = false;
      notifyListeners();
    }
  }

  void login(String email, String password) async {
    try {
      isLoading = true;
      notifyListeners();
      await auth.signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushAndRemoveUntil(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (context) => MainScreen()),
        (value) => false,
      );
    } on FirebaseAuthException catch (e) {
      showMsg(e.message);
    } catch (e) {
      showMsg(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void signUp(String name, String email, String phone, String password) async {
    try {
      isLoading = true;
      notifyListeners();
      final result = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      UserModel user = UserModel(
        id: result.user!.uid,
        name: name,
        email: email,
        phone: phone,
        createdAt: DateTime.now(),
      );
      await db.collection("users").doc(result.user!.uid).set(user.toMap());
      Navigator.pushAndRemoveUntil(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (context) => MainScreen()),
        (value) => false,
      );
    } on FirebaseAuthException catch (e) {
      showMsg(e.message);
    } catch (e) {
      showMsg(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void forgotPassword(
    String name,
    String email,
    String phone,
    String password,
  ) async {
    try {
      isLoading = true;
      notifyListeners();

      await auth.sendPasswordResetEmail(email: email);
      showMsg("check your inbox the the reset link will be received here");
    } on FirebaseAuthException catch (e) {
      showMsg(e.message);
    } catch (e) {
      showMsg(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void signOut() async {
    try {
      await auth.signOut();
      Navigator.pushAndRemoveUntil(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (value) => false,
      );
    } on FirebaseAuthException catch (e) {
      showMsg(e.message);
    } catch (e) {
      showMsg(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
