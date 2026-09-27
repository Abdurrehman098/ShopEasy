import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_easy/AdminApp/provider/admin_order_view_model.dart';
import 'package:shop_easy/UserApp/core/constant/colors.dart';
import 'package:shop_easy/UserApp/core/constant/text_style.dart';
import 'package:shop_easy/UserApp/model/orderModel/order_model.dart';

class OrderDetailsScreen extends StatefulWidget {
  final OrderModel order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late String selectedStatus;

  @override
  void initState() {
    super.initState();

    selectedStatus = widget.order.status;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminOrderProvider>(
      builder: (context, provider, child) {


        final currentOrder = provider.getOrder(widget.order.id);

        final OrderModel order = currentOrder ?? widget.order;


        if (selectedStatus != order.status && !provider.isLoading) {
          selectedStatus = order.status;
        }

        return Scaffold(
          backgroundColor: backgroundColor,

          appBar: AppBar(
            backgroundColor: whiteColor,

            elevation: 0,

            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },

              icon: const Icon(Icons.arrow_back_ios_new, size: 18),
            ),

            title: Text(
              "Order Details",

              style: style16.copyWith(
                fontWeight: FontWeight.bold,

                color: boldTextColor,
              ),
            ),
          ),


          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [


                _section(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          Expanded(
                            child: Text(
                              "#${order.id}",

                              maxLines: 1,

                              overflow: TextOverflow.ellipsis,

                              style: style14.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          const SizedBox(width: 10),

                          _statusWidget(order.status),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Text(
                        _formatDate(order.date),

                        style: style15.copyWith(
                          fontSize: 12,
                          color: secondaryColor,
                        ),
                      ),

                      const SizedBox(height: 12),

                      _detailRow("Payment Method", order.paymentMethod),
                    ],
                  ),
                ),

                const SizedBox(height: 12),


                _section(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        "Customer Details",

                        style: style14.copyWith(fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 12),

                      _detailRow("User ID", order.userId),

                      const SizedBox(height: 8),

                      _detailRow("Order Date", _formatDate(order.date)),
                    ],
                  ),
                ),

                const SizedBox(height: 12),


                _section(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        "Items (${order.items})",

                        style: style14.copyWith(fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 10),

                      if (order.products.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(10),

                          child: Center(child: Text("No products found")),
                        )
                      else
                        ListView.builder(
                          itemCount: order.products.length,

                          shrinkWrap: true,

                          physics: const NeverScrollableScrollPhysics(),

                          itemBuilder: (context, index) {
                            final product = order.products[index];

                            final quantity = order.quantities[product.id] ?? 1;

                            return _productItem(product, quantity);
                          },
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),


                _section(
                  child: Column(
                    children: [
                      _priceRow("Subtotal", order.subtotal),

                      const SizedBox(height: 8),

                      _priceRow("Delivery Fee", order.deliveryFee),

                      const SizedBox(height: 8),

                      _priceRow("Discount", -order.discount),

                      const Divider(height: 20),

                      _priceRow("Total", order.total, isTotal: true),
                    ],
                  ),
                ),

                const SizedBox(height: 16),


                Text(
                  "CHANGE ORDER STATUS",

                  style: style15.copyWith(
                    fontSize: 10,
                    color: secondaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 7),

                Container(
                  width: double.infinity,

                  padding: const EdgeInsets.symmetric(horizontal: 12),

                  decoration: BoxDecoration(
                    color: whiteColor,

                    borderRadius: BorderRadius.circular(10),
                  ),

                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedStatus,

                      isExpanded: true,

                      items: const [
                        DropdownMenuItem(
                          value: "Pending",
                          child: Text("Pending"),
                        ),

                        DropdownMenuItem(
                          value: "Processing",
                          child: Text("Processing"),
                        ),

                        DropdownMenuItem(
                          value: "Delivered",
                          child: Text("Delivered"),
                        ),

                        DropdownMenuItem(
                          value: "Cancelled",
                          child: Text("Cancelled"),
                        ),
                      ],

                      onChanged: provider.isLoading
                          ? null
                          : (value) {
                              if (value == null) {
                                return;
                              }

                              setState(() {
                                selectedStatus = value;
                              });
                            },
                    ),
                  ),
                ),

                const SizedBox(height: 12),


                SizedBox(
                  width: double.infinity,

                  height: 48,

                  child: ElevatedButton(
                    onPressed: provider.isLoading
                        ? null
                        : selectedStatus == order.status
                        ? null
                        : () async {
                            final success = await provider.updateOrderStatus(
                              order.id,
                              selectedStatus,
                            );

                            if (!context.mounted) {
                              return;
                            }

                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Order status updated"),
                                ),
                              );

                              // Updated order provider
                              // mein aa chuka hai.
                              setState(() {});
                            }
                          },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,

                      foregroundColor: whiteColor,

                      disabledBackgroundColor: Colors.grey.shade300,

                      disabledForegroundColor: Colors.grey.shade600,

                      elevation: 0,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),

                    child: provider.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,

                            child: CircularProgressIndicator(
                              strokeWidth: 2,

                              color: Colors.white,
                            ),
                          )
                        : Text(
                            selectedStatus == order.status
                                ? "Status Already ${order.status}"
                                : "Update Status",
                          ),
                  ),
                ),

                const SizedBox(height: 10),

                Center(
                  child: Text(
                    "Current Status: ${order.status}",

                    style: style15.copyWith(
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


  Widget _section({required Widget child}) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: whiteColor,

        borderRadius: BorderRadius.circular(12),
      ),

      child: child,
    );
  }


  Widget _detailRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [
        Text(
          title,

          style: style15.copyWith(fontSize: 12, color: secondaryColor),
        ),

        const SizedBox(width: 15),

        Flexible(
          child: Text(value, textAlign: TextAlign.right, style: style14),
        ),
      ],
    );
  }


  Widget _productItem(dynamic product, int quantity) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),

      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,

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
                  Icons.image_not_supported,
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

                  maxLines: 1,

                  overflow: TextOverflow.ellipsis,

                  style: style14.copyWith(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 3),

                Text(
                  "Qty: $quantity • ${product.category}",

                  maxLines: 1,

                  overflow: TextOverflow.ellipsis,

                  style: style15.copyWith(fontSize: 11, color: secondaryColor),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          Text(
            "\$${(product.price * quantity).toStringAsFixed(2)}",

            style: style14.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }


  Widget _priceRow(String title, double price, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [
        Text(
          title,

          style: style15.copyWith(
            fontSize: isTotal ? 14 : 12,

            color: isTotal ? boldTextColor : secondaryColor,

            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),

        Text(
          "\$${price.toStringAsFixed(2)}",

          style: style14.copyWith(
            color: isTotal ? Colors.teal : boldTextColor,

            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }


  Widget _statusWidget(String status) {
    Color background;
    Color textColor;

    switch (status) {
      case "Delivered":
        background = Colors.green.withOpacity(0.15);
        textColor = Colors.green;
        break;

      case "Cancelled":
        background = Colors.red.withOpacity(0.15);
        textColor = Colors.red;
        break;

      case "Processing":
        background = Colors.blue.withOpacity(0.15);
        textColor = Colors.blue;
        break;

      case "Pending":
      default:
        background = Colors.orange.withOpacity(0.15);
        textColor = Colors.orange;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),

      decoration: BoxDecoration(
        color: background,

        borderRadius: BorderRadius.circular(20),
      ),

      child: Text(
        status,

        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year} "
        "${date.hour.toString().padLeft(2, '0')}:"
        "${date.minute.toString().padLeft(2, '0')}";
  }
}
