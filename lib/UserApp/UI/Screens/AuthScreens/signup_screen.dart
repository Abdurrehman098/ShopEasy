import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_easy/UserApp/UI/Screens/AuthScreens/login_screen.dart';
import 'package:shop_easy/UserApp/core/constant/auth_decoration.dart';
import 'package:shop_easy/UserApp/core/constant/colors.dart';
import 'package:shop_easy/UserApp/core/constant/text_style.dart';
import 'package:shop_easy/UserApp/provider/auth_view_model.dart';

import '../../Widgets/customButton/custom_button.dart';
import '../../Widgets/customButton/google_btn.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context , provider , child) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
              child: Form(
                key: provider.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    SizedBox(height: 15),

                    Text("Create Account", style: style28.copyWith(color: boldTextColor)),
                    SizedBox(height: 5),
                    Text(
                      "Sign up to start your Shopping journey",
                      style: style15.copyWith(color: secondaryColor),
                    ),

                    SizedBox(height: 15),
                    Text("Full Name", style: style14.copyWith(color: boldTextColor)),
                    SizedBox(height: 5),
                    TextFormField(
                        controller: provider.name,
                        validator: provider.validateName,
                        decoration: authDecoration.copyWith(hintText: "Enter Your Full Name")),
                    SizedBox(height: 15),
                    Text("Email", style: style14.copyWith(color: boldTextColor)),
                    SizedBox(height: 5),
                    TextFormField(
                        controller: provider.email,
                        validator: provider.validateEmail,
                        decoration: authDecoration.copyWith(hintText: "Enter Your Email")),
                    SizedBox(height: 15),
                    Text("Phone Number", style: style14.copyWith(color: boldTextColor)),
                    SizedBox(height: 5),
                    TextFormField(
                        controller: provider.phone,
                        validator: provider.validatePhone,
                        decoration: authDecoration.copyWith(hintText: "Enter Your Phone Number ")),
                    SizedBox(height: 15),
                    Text("Password", style: style14.copyWith(color: boldTextColor)),
                    SizedBox(height: 5),
                    TextFormField(
                      obscureText: provider.visibility,
                      controller: provider.password,
                      validator: provider.validatePassword,
                      decoration: authDecoration.copyWith(
                        hintText: "Enter Your Password",
                        suffixIcon: IconButton(
                          onPressed: () {
                            provider.passwordVisibility();
                          },
                          icon: Icon(provider.visibility ? Icons.visibility : Icons.visibility_off ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text("Confirm Password", style: style14.copyWith(color: boldTextColor)),
                    SizedBox(height: 5),
                    TextFormField(
                      obscureText: provider.confirmVisibility,
                      controller: provider.confirmPassword,
                      validator:(value){ return provider.validateConfirmPassword(value, provider.password.text);},
                      decoration: authDecoration.copyWith(
                        hintText: "Re-enter Your Password",
                        suffixIcon: IconButton(
                          onPressed: () {
                            provider.confirmPasswordVisibility();
                          },
                          icon: Icon(provider.confirmVisibility ? Icons.visibility : Icons.visibility_off ),

                        ),
                      ),
                    ),

                    SizedBox(height: 50),
                    InkWell(onTap: provider.isLoading ? null :() {
                      if(provider.formKey.currentState!.validate()){
                        provider.signUp(provider.name.text, provider.email.text.trim(), provider.phone.text.trim(), provider.password.text.trim());

                      }

                    },

                        child: CustomButton(child:provider.isLoading? CircularProgressIndicator(color: Colors.white,): Text("SignUp" , style: style16.copyWith(color: whiteColor ,fontWeight: FontWeight.bold)))),
                    SizedBox(height: 15),

                    Row(
                      children: [
                        Expanded(child: Container(height: 1, color: Color(0xffE2E2E9))),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text("OR"),
                        ),
                        Expanded(child: Container(height: 1, color: Color(0xffE2E2E9))),
                      ],
                    ),
                    SizedBox(height: 15),
                    InkWell(onTap:provider.googleLoading?  null :() {
                      provider.continueWithGoogle();
                    }, child: GoogleBtn(googleLoading: provider.googleLoading,)),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an Account?"),
                        SizedBox(width: 5),
                        TextButton(
                          onPressed: () {
                            Navigator.push(context,MaterialPageRoute(builder: (context) => LoginScreen(),));
                          },
                          child: Text("Login", style: style14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}
