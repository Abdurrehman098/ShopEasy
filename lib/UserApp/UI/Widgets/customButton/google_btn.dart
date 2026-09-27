import 'package:flutter/material.dart';
import 'package:shop_easy/UserApp/core/constant/colors.dart';
import 'package:shop_easy/UserApp/core/constant/string.dart';

class GoogleBtn extends StatelessWidget {
 final bool googleLoading;
  const GoogleBtn({super.key , this.googleLoading = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: whiteColor
      ),
      child: googleLoading ? CircularProgressIndicator(color: primaryColor,) :Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("$iconAssets/googleIcon.png" ,scale: 50,),
          SizedBox(width: 5,),
          Text("Continue With Google")
        ],
      ),
    );
  }
}
