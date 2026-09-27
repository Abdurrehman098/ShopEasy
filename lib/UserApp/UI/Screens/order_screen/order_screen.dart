import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_easy/UserApp/UI/Screens/order_screen/OrderDetailScreen/order_detail_screen.dart';
import 'package:shop_easy/UserApp/core/constant/colors.dart';
import 'package:shop_easy/UserApp/core/constant/text_style.dart';
import 'package:shop_easy/UserApp/provider/product_view_model.dart';
import 'package:shop_easy/main.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final provider = Provider.of<ProductViewModel>(
          navigatorKey.currentContext!,
          listen: false,
        );

        provider.getOrders(user.uid);
      }
    });
  }

  String formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
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
            title: Text(
              "My Orders",
              style: style28.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          body: provider.isLoadingOrders
              ? const Center(
            child: CircularProgressIndicator(),
          )
              : provider.orderError.isNotEmpty
              ? Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                provider.orderError,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          )
              : provider.orders.isEmpty
              ? _emptyOrders(context)
              : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.orders.length,
            itemBuilder: (context, index) {
              final order = provider.orders[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 14),

                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey.shade300,
                  ),
                ),

                child: Padding(
                  padding: const EdgeInsets.all(15),

                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,

                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Order #${order.id}",
                                  style: style16.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow:
                                  TextOverflow.ellipsis,
                                ),

                                const SizedBox(height: 5),

                                Text(
                                  "Placed on ${formatDate(order.date)}",
                                  style: TextStyle(
                                    color: secondaryColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 10),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 10,
                            ),

                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(20),
                              color: const Color(0xffFEF3C7),
                            ),

                            child: Text(
                              order.status,
                              style: const TextStyle(
                                color: Color(0xffF59E0B),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Divider(
                        color: Colors.grey.shade200,
                      ),

                      const SizedBox(height: 5),

                      Row(
                        children: [
                          Text(
                            "${order.items} Items",
                            style: style14,
                          ),

                          const SizedBox(width: 8),

                          Text(
                            "•",
                            style: TextStyle(
                              color: secondaryColor,
                            ),
                          ),

                          const SizedBox(width: 8),

                          Text(
                            "\$ ${order.total.toStringAsFixed(2)}",
                            style: style14.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const Spacer(),

                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      OrderDetailsScreen(
                                        order: order,
                                      ),
                                ),
                              );
                            },

                            child: Text(
                              "View Details",
                              style: style14.copyWith(
                                color: primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

Widget _emptyOrders(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(20),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Container(
            width: 96,
            height: 96,

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: whiteColor,
            ),

            child: const Icon(
              Icons.receipt_long_outlined,
              size: 44,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 20),

          Text(
            "No Orders Yet",
            style: style28.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            "You have not placed any order yet.\nLet's find your first purchase!",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 30),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: whiteColor,

              minimumSize: const Size(
                220,
                50,
              ),

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),

            onPressed: () {
              Navigator.pop(context);
            },

            child: const Text(
              "Shop Now",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}