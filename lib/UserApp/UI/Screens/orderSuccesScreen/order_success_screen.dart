import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_easy/UserApp/UI/Screens/MainScreen/main_screen.dart';
import 'package:shop_easy/UserApp/UI/Screens/order_screen/order_screen.dart';
import 'package:shop_easy/UserApp/core/constant/colors.dart';
import 'package:shop_easy/UserApp/core/constant/text_style.dart';
import 'package:shop_easy/UserApp/provider/product_view_model.dart';

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductViewModel>(
      builder: (context, provider, child) {
        if (provider.orders.isEmpty) {
          return Scaffold(
            backgroundColor: backgroundColor,

            appBar: AppBar(backgroundColor: backgroundColor, elevation: 0),

            body: Center(
              child: Text(
                "No Order Found",
                style: style28.copyWith(fontSize: 20, color: Colors.green),
              ),
            ),
          );
        }

        final order = provider.orders.first;

        return Scaffold(
          backgroundColor: backgroundColor,

          appBar: AppBar(
            backgroundColor: backgroundColor,
            elevation: 0,
            automaticallyImplyLeading: false,
          ),

          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),

              child: Column(
                children: [
                  const SizedBox(height: 30),

                  Container(
                    height: 80,
                    width: 80,

                    decoration: const BoxDecoration(
                      color: Color(0xffD1FAE5),
                      shape: BoxShape.circle,
                    ),

                    child: const Icon(
                      Icons.check,
                      color: Colors.green,
                      size: 45,
                    ),
                  ),

                  const SizedBox(height: 18),

                  Text(
                    "Order Placed!",
                    style: style28.copyWith(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "Your order has been placed successfully.",
                    textAlign: TextAlign.center,
                    style: style15.copyWith(color: secondaryColor),
                  ),

                  const SizedBox(height: 25),

                  Container(
                    width: double.infinity,

                    padding: const EdgeInsets.all(16),

                    decoration: BoxDecoration(
                      color: whiteColor,

                      borderRadius: BorderRadius.circular(12),

                      border: Border.all(color: Colors.grey.shade300),
                    ),

                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text(
                              "Order ID",
                              style: style15.copyWith(color: secondaryColor),
                            ),

                            const SizedBox(width: 15),

                            Expanded(
                              child: Text(
                                order.id,
                                textAlign: TextAlign.end,

                                maxLines: 2,

                                overflow: TextOverflow.ellipsis,

                                style: style14.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            Text(
                              "Payment Method",
                              style: style15.copyWith(color: secondaryColor),
                            ),

                            const SizedBox(width: 10),

                            Flexible(
                              child: Text(
                                order.paymentMethod,
                                textAlign: TextAlign.end,

                                style: style14.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            Text(
                              "Estimated Delivery",
                              style: style15.copyWith(color: secondaryColor),
                            ),

                            Text(
                              "3-5 Business Days",

                              style: style14.copyWith(
                                color: primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        Divider(color: Colors.grey.shade200),

                        const SizedBox(height: 10),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            Text(
                              "Total",
                              style: style15.copyWith(color: secondaryColor),
                            ),

                            Text(
                              "\$ ${order.total.toStringAsFixed(2)}",

                              style: style16.copyWith(
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  SizedBox(
                    width: double.infinity,
                    height: 55,

                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,

                          MaterialPageRoute(
                            builder: (context) => const MainScreen(),
                          ),

                          (route) => false,
                        );
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: whiteColor,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),

                      child: Text(
                        "Continue Shopping",

                        style: style14.copyWith(
                          color: whiteColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    height: 55,

                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,

                          MaterialPageRoute(
                            builder: (context) => const OrderScreen(),
                          ),
                        );
                      },

                      style: OutlinedButton.styleFrom(
                        foregroundColor: primaryColor,

                        side: BorderSide(color: primaryColor),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),

                      child: Text(
                        "View My Orders",

                        style: style14.copyWith(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
