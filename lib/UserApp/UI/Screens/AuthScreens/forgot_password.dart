import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_easy/UserApp/UI/Widgets/customButton/custom_button.dart';
import 'package:shop_easy/UserApp/core/constant/auth_decoration.dart';
import 'package:shop_easy/UserApp/core/constant/colors.dart';
import 'package:shop_easy/UserApp/core/constant/text_style.dart';
import 'package:shop_easy/UserApp/provider/auth_view_model.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(),

          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
              child: Form(
                key: provider.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 76,
                      height: 76,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(36),
                        color: const Color(0x155B5FEF),
                      ),
                      child: Icon(
                        Icons.lock_open_outlined,
                        size: 36,
                        color: primaryColor,
                      ),
                    ),
                    SizedBox(height: 15),

                    Text(
                      "Forgot Password",
                      style: style28.copyWith(color: boldTextColor),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Enter your email address ans we will send you a link to reset your password.",
                      style: style15.copyWith(color: secondaryColor),
                    ),

                    SizedBox(height: 25),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Email",
                        style: style14.copyWith(color: boldTextColor),
                      ),
                    ),
                    SizedBox(height: 5),
                    TextFormField(
                      controller: provider.email,
                      validator: provider.validateEmail,
                      decoration: authDecoration,
                    ),
                    SizedBox(height: 25),
                    InkWell(
                      onTap: provider.isLoading
                          ? null
                          : () {
                              if (provider.formKey.currentState!.validate()) {
                                provider.signOut();
                              }
                            },
                      child: CustomButton(
                        child: provider.isLoading
                            ? CircularProgressIndicator(color: whiteColor)
                            : Text(
                                "Send Reset Link",
                                style: style16.copyWith(
                                  color: whiteColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
