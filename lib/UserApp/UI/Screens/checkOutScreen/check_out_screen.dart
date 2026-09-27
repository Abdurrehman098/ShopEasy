import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_easy/UserApp/UI/Screens/orderSuccesScreen/order_success_screen.dart';
import 'package:shop_easy/UserApp/core/constant/colors.dart';
import 'package:shop_easy/UserApp/core/constant/text_style.dart';
import 'package:shop_easy/UserApp/provider/product_view_model.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  String userName = "User";
  String userPhone = "No phone number";
  String userAddress = "No address available";

  bool isLoadingUser = true;
  bool isPlacingOrder = false;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    try {
      final user = auth.currentUser;

      if (user == null) {
        if (mounted) {
          setState(() {
            isLoadingUser = false;
          });
        }
        return;
      }

      userName = user.displayName?.trim().isNotEmpty == true
          ? user.displayName!.trim()
          : "User";

      // Firestore user document
      final doc = await db.collection("users").doc(user.uid).get();

      if (doc.exists) {
        final data = doc.data();

        if (data != null) {
          final firestoreName = data["name"]?.toString().trim();
          final phone = data["phone"]?.toString().trim();
          final address = data["address"]?.toString().trim();

          if (firestoreName != null && firestoreName.isNotEmpty) {
            userName = firestoreName;
          }

          if (phone != null && phone.isNotEmpty) {
            userPhone = phone;
          }

          if (address != null && address.isNotEmpty) {
            userAddress = address;
          }
        }
      }
    } catch (e) {
      debugPrint("Checkout User Data Error: $e");
    } finally {
      if (mounted) {
        setState(() {
          isLoadingUser = false;
        });
      }
    }
  }

  Future<void> placeOrder(ProductViewModel provider) async {
    final user = auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please login before placing an order."),
        ),
      );
      return;
    }

    if (provider.cartProducts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Your cart is empty."),
        ),
      );
      return;
    }

    try {
      setState(() {
        isPlacingOrder = true;
      });

      // Firebase mein order save hoga
      await provider.placeOrder(
        userId: user.uid,
        paymentMethod: "Cash on Delivery",
      );

      // Agar provider mein error aya
      if (provider.orderError.isNotEmpty) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.orderError),
            backgroundColor: Colors.red,
          ),
        );

        return;
      }

      if (!mounted) return;

      // Order successfully place hone ke baad success screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const OrderSuccessScreen(),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to place order: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isPlacingOrder = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductViewModel>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: backgroundColor,

          appBar: AppBar(
            backgroundColor: whiteColor,
            elevation: 0,
            scrolledUnderElevation: 0,
            title: Text(
              "Checkout",
              style: style28.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          body: isLoadingUser
              ? const Center(
            child: CircularProgressIndicator(),
          )
              : SingleChildScrollView(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  "DELIVERY ADDRESS",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: secondaryColor,
                  ),
                ),

                const SizedBox(height: 8),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),

                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.shade300,
                    ),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              userName,
                              style: style14.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          Text(
                            "Default",
                            style: style14.copyWith(
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Row(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.phone_outlined,
                            size: 18,
                            color: secondaryColor,
                          ),

                          const SizedBox(width: 8),

                          Expanded(
                            child: Text(
                              userPhone,
                              style: TextStyle(
                                color: secondaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Row(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 18,
                            color: secondaryColor,
                          ),

                          const SizedBox(width: 8),

                          Expanded(
                            child: Text(
                              userAddress,
                              style: TextStyle(
                                color: secondaryColor,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),


                Text(
                  "PAYMENT METHOD",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: secondaryColor,
                  ),
                ),

                const SizedBox(height: 8),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 13,
                    horizontal: 14,
                  ),

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: whiteColor,
                    border: Border.all(
                      color: Colors.grey.shade300,
                    ),
                  ),

                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,

                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),

                        child: Icon(
                          Icons.local_atm_outlined,
                          color: primaryColor,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Cash on Delivery",
                              style: style14.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            const SizedBox(height: 3),

                            Text(
                              "Pay when your order arrives",
                              style: TextStyle(
                                fontSize: 11,
                                color: secondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Icon(
                        Icons.radio_button_checked,
                        color: primaryColor,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // =========================
                // ORDER SUMMARY
                // =========================

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),

                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.shade300,
                    ),
                  ),

                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [
                      Text(
                        "Order Summary",
                        style: style16.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Divider(
                        color: Colors.grey.shade200,
                      ),

                      const SizedBox(height: 8),

                      // Items
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Items",
                            style: style15.copyWith(
                              color: secondaryColor,
                            ),
                          ),

                          Text(
                            "${provider.cartItemCount}",
                            style: style14,
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // Subtotal
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Subtotal",
                            style: style15.copyWith(
                              color: secondaryColor,
                            ),
                          ),

                          Text(
                            "\$ ${provider.subtotal.toStringAsFixed(2)}",
                            style: style14,
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // Delivery
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Delivery",
                            style: style15.copyWith(
                              color: secondaryColor,
                            ),
                          ),

                          Text(
                            "\$ ${provider.deliveryCharge.toStringAsFixed(2)}",
                            style: style14.copyWith(
                              color: secondaryColor,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // Discount
                      if (provider.discount > 0)
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Discount",
                              style: style15.copyWith(
                                color: Colors.green,
                              ),
                            ),

                            Text(
                              "- \$ ${provider.discount.toStringAsFixed(2)}",
                              style: style14.copyWith(
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),

                      const SizedBox(height: 10),

                      Divider(
                        color: Colors.grey.shade200,
                      ),

                      const SizedBox(height: 10),

                      // Total
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total Amount",
                            style: style16.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          Text(
                            "\$ ${provider.total.toStringAsFixed(2)}",
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

                const SizedBox(height: 25),

                // =========================
                // PLACE ORDER BUTTON
                // =========================

                SizedBox(
                  width: double.infinity,
                  height: 58,

                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: whiteColor,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),

                    onPressed: isPlacingOrder ||
                        provider.cartProducts.isEmpty
                        ? null
                        : () {
                      placeOrder(provider);
                    },

                    child: isPlacingOrder
                        ? const SizedBox(
                      width: 24,
                      height: 24,
                      child:
                      CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                        : Text(
                      "Place Order",
                      style: style16.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                Center(
                  child: Text(
                    "By placing your order, you agree to our terms and conditions.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      color: secondaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}