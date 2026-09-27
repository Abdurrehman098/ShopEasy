import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_easy/AdminApp/UI/Screens/Dashboard/main_screen.dart';
import 'package:shop_easy/AdminApp/UI/utills/show_message.dart';
import 'package:shop_easy/AdminApp/provider/admin_auth_view_model.dart';
import 'package:shop_easy/UserApp/core/constant/colors.dart';
import 'package:shop_easy/UserApp/core/constant/text_style.dart';
import 'package:shop_easy/admin_main.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final provider = context.read<AdminAuthProvider>();

    final success = await provider.login(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    if (success) {
      showMsg("Login successful", false);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
        (value) => false,
      );
    } else {
      showMsg(provider.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Container(
            width: 400,

            padding: const EdgeInsets.all(25),

            decoration: BoxDecoration(
              color: whiteColor,

              borderRadius: BorderRadius.circular(15),

              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),

            child: Consumer<AdminAuthProvider>(
              builder: (context, provider, child) {
                return Form(
                  key: formKey,

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Center(
                        child: Container(
                          height: 65,
                          width: 65,

                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(15),
                          ),

                          child: const Icon(
                            Icons.shopping_bag_outlined,
                            color: Colors.white,
                            size: 38,
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      Center(
                        child: Text(
                          "ShopEasy",
                          style: style28.copyWith(color: boldTextColor),
                        ),
                      ),

                      const SizedBox(height: 5),

                      Center(
                        child: Text(
                          "Admin Panel",
                          style: style15.copyWith(color: secondaryColor),
                        ),
                      ),

                      const SizedBox(height: 30),

                      Text(
                        "Email",
                        style: style14.copyWith(color: boldTextColor),
                      ),

                      const SizedBox(height: 8),

                      TextFormField(
                        controller: emailController,

                        keyboardType: TextInputType.emailAddress,

                        decoration: InputDecoration(
                          hintText: "Enter your email",

                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: secondaryColor,
                          ),

                          filled: true,
                          fillColor: backgroundColor,

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),

                            borderSide: BorderSide.none,
                          ),

                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),

                            borderSide: BorderSide.none,
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),

                            borderSide: BorderSide(color: primaryColor),
                          ),
                        ),

                        validator: (value) {
                          return provider.validateEmail(value!.trim());
                        },
                      ),

                      const SizedBox(height: 18),

                      Text(
                        "Password",
                        style: style14.copyWith(color: boldTextColor),
                      ),

                      const SizedBox(height: 8),

                      TextFormField(
                        controller: passwordController,

                        obscureText: provider.visibility,

                        decoration: InputDecoration(
                          hintText: "Enter your password",

                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: secondaryColor,
                          ),

                          suffixIcon: IconButton(
                            onPressed: () {
                              provider.passwordVisibility();
                            },

                            icon: Icon(
                              provider.visibility
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,

                              color: secondaryColor,
                            ),
                          ),

                          filled: true,
                          fillColor: backgroundColor,

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),

                            borderSide: BorderSide.none,
                          ),

                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),

                            borderSide: BorderSide.none,
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),

                            borderSide: BorderSide(color: primaryColor),
                          ),
                        ),

                        validator: (value) {
                          return provider.validatePassword(value!.trim());
                        },
                      ),

                      const SizedBox(height: 25),

                      SizedBox(
                        width: double.infinity,
                        height: 50,

                        child: ElevatedButton(
                          onPressed: provider.isLoading ? null : login,

                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,

                            disabledBackgroundColor: primaryColor,

                            elevation: 0,

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),

                          child: provider.isLoading
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,

                                  child: CircularProgressIndicator(
                                    color: whiteColor,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  "Login",
                                  style: style16.copyWith(color: whiteColor),
                                ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
