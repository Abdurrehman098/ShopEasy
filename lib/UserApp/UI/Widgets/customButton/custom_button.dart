import 'package:flutter/cupertino.dart';
import 'package:shop_easy/UserApp/core/constant/colors.dart';


class CustomButton extends StatelessWidget {
  final Widget child;

   const CustomButton({super.key , required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(child: child ,)




    );
  }
}
