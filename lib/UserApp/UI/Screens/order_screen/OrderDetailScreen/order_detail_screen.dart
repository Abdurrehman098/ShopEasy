import 'package:flutter/material.dart';
import 'package:shop_easy/UserApp/core/constant/colors.dart';
import 'package:shop_easy/UserApp/core/constant/text_style.dart';
import 'package:shop_easy/UserApp/model/orderModel/order_model.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderModel order;

  const OrderDetailsScreen({super.key, required this.order});

  String formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
  }

  int getStatusIndex(String status) {
    switch (status.toLowerCase()) {
      case "pending":
        return 0;

      case "confirmed":
        return 1;

      case "shipped":
        return 2;

      case "delivered":
        return 3;

      case "cancelled":
        return -1;

      default:
        return 0;
    }
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "pending":
        return Colors.orange;

      case "confirmed":
        return Colors.blue;

      case "shipped":
        return Colors.deepPurple;

      case "delivered":
        return Colors.green;

      case "cancelled":
        return Colors.red;

      default:
        return secondaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentStatusIndex = getStatusIndex(order.status);

    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0,
        scrolledUnderElevation: 0,

        title: Text(
          "Order Details",
          style: style16.copyWith(fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),

              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Expanded(
                        child: Text(
                          "Order #${order.id}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,

                          style: style14.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),

                        decoration: BoxDecoration(
                          color: getStatusColor(order.status),

                          borderRadius: BorderRadius.circular(20),
                        ),

                        child: Text(
                          order.status,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: getStatusColor(order.status),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Placed on ${formatDate(order.date)}",
                    style: TextStyle(fontSize: 11, color: secondaryColor),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),

              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    "ORDER STATUS",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: secondaryColor,
                    ),
                  ),

                  const SizedBox(height: 20),

                  if (order.status.toLowerCase() == "cancelled")
                    _cancelledStatus()
                  else
                    _orderStatusTimeline(currentStatusIndex),
                ],
              ),
            ),

            const SizedBox(height: 18),

            Text(
              "ITEMS (${order.items})",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: secondaryColor,
              ),
            ),

            const SizedBox(height: 8),

            ListView.builder(
              itemCount: order.products.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),

              itemBuilder: (context, index) {
                final product = order.products[index];

                final quantity = order.quantities[product.id] ?? 1;

                final itemTotal = product.price * quantity;

                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(9),

                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300),
                  ),

                  child: Row(
                    children: [
                      // Product Image
                      Container(
                        height: 55,
                        width: 55,
                        padding: const EdgeInsets.all(5),

                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(8),
                        ),

                        child: Image.asset(
                          product.image,
                          fit: BoxFit.contain,

                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.image_not_supported_outlined,
                              color: Colors.grey,
                            );
                          },
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text(
                              product.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,

                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            const SizedBox(height: 5),

                            Text(
                              "Qty: $quantity",
                              style: TextStyle(
                                fontSize: 11,
                                color: secondaryColor,
                              ),
                            ),

                            const SizedBox(height: 3),

                            Text(
                              "\$${product.price.toStringAsFixed(2)} each",
                              style: TextStyle(
                                fontSize: 10,
                                color: secondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 8),

                      // Item Total
                      Text(
                        "\$${itemTotal.toStringAsFixed(2)}",

                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 10),

            Text(
              "DELIVERY DETAILS",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
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
                border: Border.all(color: Colors.grey.shade300),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  const Text(
                    "Delivery Address",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Your delivery address was provided during checkout.",
                    style: TextStyle(
                      fontSize: 11,
                      color: secondaryColor,
                      height: 1.4,
                    ),
                  ),

                  const Divider(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Text(
                        "Payment Method",
                        style: TextStyle(fontSize: 11, color: secondaryColor),
                      ),

                      Flexible(
                        child: Text(
                          order.paymentMethod,
                          textAlign: TextAlign.end,

                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),

              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),

              child: Column(
                children: [
                  // Subtotal
                  _priceRow(
                    title: "Subtotal",
                    value: "\$${order.subtotal.toStringAsFixed(2)}",
                  ),

                  const SizedBox(height: 9),

                  _priceRow(
                    title: "Delivery Fee",
                    value: "\$${order.deliveryFee.toStringAsFixed(2)}",
                  ),

                  const SizedBox(height: 9),

                  _priceRow(
                    title: "Discount",
                    value: "-\$${order.discount.toStringAsFixed(2)}",
                    valueColor: Colors.green,
                  ),

                  const Divider(height: 24),

                  // Total
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      const Text(
                        "Total Amount",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        "\$${order.total.toStringAsFixed(2)}",

                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _priceRow({
    required String title,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [
        Text(title, style: TextStyle(fontSize: 11, color: secondaryColor)),

        Text(
          value,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  Widget _orderStatusTimeline(int currentIndex) {
    const statuses = ["Ordered", "Confirmed", "Shipped", "Delivered"];

    return Row(
      children: List.generate(statuses.length * 2 - 1, (index) {
        // Status circle
        if (index.isEven) {
          final statusIndex = index ~/ 2;

          final isCompleted = statusIndex <= currentIndex;

          return Column(
            children: [
              Container(
                height: 18,
                width: 18,

                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  color: isCompleted ? primaryColor : whiteColor,

                  border: Border.all(
                    color: isCompleted ? primaryColor : Colors.grey.shade300,
                    width: 1.5,
                  ),
                ),

                child: isCompleted
                    ? const Icon(Icons.check, size: 11, color: Colors.white)
                    : null,
              ),

              const SizedBox(height: 6),

              Text(
                statuses[statusIndex],
                style: TextStyle(
                  fontSize: 8,
                  color: isCompleted ? primaryColor : secondaryColor,
                  fontWeight: isCompleted ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          );
        }

        // Connecting line
        final lineIndex = index ~/ 2;

        final isCompleted = lineIndex < currentIndex;

        return Expanded(
          child: Container(
            height: 2,

            margin: const EdgeInsets.only(bottom: 22),

            color: isCompleted ? primaryColor : Colors.grey.shade300,
          ),
        );
      }),
    );
  }

  Widget _cancelledStatus() {
    return Row(
      children: [
        Container(
          height: 18,
          width: 18,

          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.red,
          ),

          child: const Icon(Icons.close, size: 12, color: Colors.white),
        ),

        const SizedBox(width: 10),

        const Text(
          "Order Cancelled",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.red,
          ),
        ),
      ],
    );
  }
}
