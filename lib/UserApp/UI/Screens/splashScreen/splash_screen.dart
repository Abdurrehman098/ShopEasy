import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_easy/UserApp/UI/Screens/AuthScreens/login_screen.dart';
import 'package:shop_easy/UserApp/UI/Screens/MainScreen/main_screen.dart';
import 'package:shop_easy/UserApp/core/constant/colors.dart';
import 'package:shop_easy/UserApp/core/constant/text_style.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  void nextScreen() {
    if (auth.currentUser == null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (value) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
        (value) => false,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      if (!mounted) {
        return;
      }
      nextScreen();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Column(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor,
                    blurRadius: 12,
                    offset: Offset(4, 0),
                  ),
                ],
              ),

              child: Icon(
                Icons.shopping_bag_outlined,
                color: primaryColor,
                size: 48,
              ),
            ),
            Text("ShopEasy", style: style36.copyWith(color: whiteColor)),
            Text("Simple Shopping", style: TextStyle(color: whiteColor)),
          ],
        ),
      ),
    );
  }
}
