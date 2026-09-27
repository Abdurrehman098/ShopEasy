import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_easy/AdminApp/provider/admin_dashboard_view_model.dart';

import 'package:shop_easy/UserApp/core/constant/colors.dart';
import 'package:shop_easy/UserApp/core/constant/text_style.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  void initState() {
    super.initState();

    // Dashboard open hote hi data load hoga
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AdminDashboardProvider>(
        context,
        listen: false,
      ).getDashboardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminDashboardProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: backgroundColor,

          appBar: AppBar(
            backgroundColor: whiteColor,
            elevation: 0,

            title: Row(
              children: [
                Icon(
                  Icons.shopping_bag_outlined,
                  color: primaryColor,
                  size: 28,
                ),

                const SizedBox(width: 8),

                Text(
                  "ShopEasy Admin",
                  style: style16.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            actions: [
              IconButton(
                onPressed: () {
                  provider.getDashboardData();
                },
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),

          body: provider.isLoading
              ? const Center(
            child: CircularProgressIndicator(),
          )
              : provider.error.isNotEmpty
              ? Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                provider.error,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          )
              : SingleChildScrollView(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  "Dashboard",
                  style: style28.copyWith(
                    fontSize: 24,
                  ),
                ),

                const SizedBox(height: 20),


                Row(
                  children: [
                    Expanded(
                      child: _statCard(
                        "Products",
                        provider.totalProducts.toString(),
                        Icons.shopping_bag_outlined,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: _statCard(
                        "Categories",
                        provider.totalCategories.toString(),
                        Icons.category_outlined,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // ==============================
                // SECOND ROW
                // ==============================

                Row(
                  children: [
                    Expanded(
                      child: _statCard(
                        "Orders",
                        provider.totalOrders.toString(),
                        Icons.shopping_cart_outlined,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: _statCard(
                        "Customers",
                        provider.totalCustomers.toString(),
                        Icons.people_outline,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                Text(
                  "Recent Orders",
                  style: style16.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                provider.recentOrders.isEmpty
                    ? Container(
                  width: double.infinity,

                  padding: const EdgeInsets.all(25),

                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius:
                    BorderRadius.circular(12),
                  ),

                  child: const Center(
                    child: Text(
                      "No orders found",
                    ),
                  ),
                )
                    : ListView.builder(
                  shrinkWrap: true,

                  physics:
                  const NeverScrollableScrollPhysics(),

                  itemCount:
                  provider.recentOrders.length,

                  itemBuilder: (context, index) {
                    final order =
                    provider.recentOrders[index];

                    return _orderCard(order);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }



  Widget _statCard(
      String title,
      String value,
      IconData icon,
      ) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(12),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,

            children: [
              Text(
                value,
                style: style28.copyWith(
                  fontSize: 24,
                ),
              ),

              Container(
                padding: const EdgeInsets.all(8),

                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius:
                  BorderRadius.circular(8),
                ),

                child: Icon(
                  icon,
                  color: primaryColor,
                  size: 20,
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          Text(
            title,
            style: style14.copyWith(
              color: secondaryColor,
            ),
          ),
        ],
      ),
    );
  }



  Widget _orderCard(
      Map<String, dynamic> order,
      ) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 10,
      ),

      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(12),
      ),

      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),

            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius:
              BorderRadius.circular(8),
            ),

            child: Icon(
              Icons.shopping_bag_outlined,
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
                  "#${order["id"]}",
                  style: style14.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  "User: ${order["userId"]}",
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,

                  style: style15.copyWith(
                    color: secondaryColor,
                  ),
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment:
            CrossAxisAlignment.end,

            children: [
              Text(
                "\$${(order["total"] as double).toStringAsFixed(2)}",
                style: style14.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                order["status"].toString(),
                style: style14.copyWith(
                  color: _getStatusColor(
                    order["status"].toString(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }



  Color _getStatusColor(
      String status,
      ) {
    if (status == "Delivered") {
      return Colors.green;
    }

    if (status == "Cancelled") {
      return Colors.red;
    }

    if (status == "Processing") {
      return Colors.orange;
    }

    return Colors.blue;
  }
}