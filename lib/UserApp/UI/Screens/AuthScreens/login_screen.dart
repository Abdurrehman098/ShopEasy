
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_easy/UserApp/UI/Screens/AuthScreens/forgot_password.dart';
import 'package:shop_easy/UserApp/UI/Screens/AuthScreens/signup_screen.dart';
import 'package:shop_easy/UserApp/UI/Widgets/customButton/custom_button.dart';
import 'package:shop_easy/UserApp/UI/Widgets/customButton/google_btn.dart';

import 'package:shop_easy/UserApp/core/constant/auth_decoration.dart';
import 'package:shop_easy/UserApp/core/constant/colors.dart';
import 'package:shop_easy/UserApp/core/constant/text_style.dart';
import 'package:shop_easy/UserApp/provider/auth_view_model.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context , provider , child) {
        return Scaffold(
          backgroundColor: backgroundColor,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 40, left: 24, right: 24),
              child: Form(
                key: provider.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.shopping_bag_outlined, color: whiteColor),
                    ),
                    SizedBox(height: 15),

                    Text("Welcome Back", style: style28.copyWith(color: boldTextColor)),
                    SizedBox(height: 5),
                    Text(
                      "Login To Continue Shopping",
                      style: style15.copyWith(color: secondaryColor),
                    ),

                    SizedBox(height: 15),
                    Text("Email", style: style14.copyWith(color: boldTextColor)),
                    SizedBox(height: 5),
                    TextFormField(
                        controller: provider.email,
                        validator: provider.validateEmail,
                        decoration: authDecoration),
                    SizedBox(height: 15),
                    Text("Password", style: style14.copyWith(color: boldTextColor)),
                    SizedBox(height: 5),
                    TextFormField(
                      controller: provider.password,
                      validator: provider.validatePassword,
                      decoration: authDecoration.copyWith(
                        hintText: "........",
                        suffixIcon: IconButton(
                          onPressed: () {
                            provider.passwordVisibility();
                          },
                          icon: Icon(provider.visibility ?Icons.visibility : Icons.visibility_off),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPassword(),));
                          },
                          child: Text(
                            "Forgot Password?",
                            style: style14.copyWith(color: primaryColor),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 50,),
                    InkWell(
                        onTap: provider.isLoading ? null :(){
                          if(provider.formKey.currentState!.validate()) {
                            provider.login(provider.email.text.trim(),
                                provider.password.text.trim());
                          }
                        },
                        child: CustomButton(child: provider.isLoading ? CircularProgressIndicator(color: whiteColor,) :Text("Login" , style: style16.copyWith(color: whiteColor ,fontWeight: FontWeight.bold) , ),), ),
                    SizedBox(height: 15,),

                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 1,
                            color: Color(0xffE2E2E9),

                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text("OR"),
                        ),
                        Expanded(
                          child: Container(
                            height: 1,
                            color: Color(0xffE2E2E9),

                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 15,),
                    InkWell(
                      onTap:provider.googleLoading ? null : (){
                        provider.continueWithGoogle();
                      },
                      child: GoogleBtn(googleLoading: provider.googleLoading,),
                    ),
                   SizedBox(height: 15,),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Text("Don't have an Account?"),
                       SizedBox(width: 5,),
                       TextButton(onPressed: (){
                       Navigator.push(context, MaterialPageRoute(builder: (context) => SignupScreen(),));
                       }, child:Text("SignUp" ,style: style14,)),

                     ],
                   )

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
