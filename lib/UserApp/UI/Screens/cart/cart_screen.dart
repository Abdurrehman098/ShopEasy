import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_easy/UserApp/UI/Screens/checkOutScreen/check_out_screen.dart';
import 'package:shop_easy/UserApp/core/constant/colors.dart';
import 'package:shop_easy/UserApp/core/constant/text_style.dart';
import 'package:shop_easy/UserApp/provider/product_view_model.dart';


class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProductViewModel>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(title: Text("My Cart", style: style28)),

          body:
          provider.cartProducts.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.shopping_cart_outlined,
                        size: 70,
                        color: Colors.grey,
                      ),

                      const SizedBox(height: 15),

                      const Text(
                        "Your Cart is Empty",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        "Add some products to your cart",
                        style: TextStyle(color: Colors.grey),
                      ),

                      const SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: () {
                          provider.onClick(0);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Continue Shopping"),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: provider.cartProducts.length + 1,
                          itemBuilder: (context, index) {
                            if (index < provider.cartProducts.length) {
                              final product = provider.cartProducts[index];
                              final quantity = provider.getQuantity(product.id);

                              return Container(
                                margin: EdgeInsets.only(bottom: 20),
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(color: whiteColor ,
                                borderRadius: BorderRadius.circular(12),
                                ),

                                child: Row(
                                  children: [
                                    Image.asset(
                                      product.image,
                                      width: 70,
                                      height: 70,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return SizedBox(
                                          width: 70,
                                          height: 70,
                                          child: Icon(
                                            Icons.image_not_supported,
                                            color: Colors.grey,
                                          ),
                                        );
                                      },
                                    ),
                                    SizedBox(width: 5),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(product.name,

                                            style: style14,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 7),
                                          Text(
                                           "\$ ${ product.price.toStringAsFixed(0)}",
                                            style: style14.copyWith(
                                              color: primaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Spacer(),
                                    Column(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            provider.removeFromCart(product);
                                          },
                                          icon: Icon(Icons.delete_outline),
                                        ),
                                        SizedBox(height: 7),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Color(0xffF7F7F9),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  provider.decreaseQuantity(product.id);
                                                },
                                                icon: Icon(Icons.remove),
                                              ),

                                              Text(quantity.toString()),
                                              IconButton(
                                                onPressed: () {
                                                  provider.increaseQuantity(product.id);
                                                },
                                                icon: Icon(Icons.add),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }
                            return Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: secondaryColor),
                                  ),
                                  child: Column(
                                    children: [
                                      Text("Order Summary", style: style14),
                                      SizedBox(height: 3),
                                      Divider(),
                                      SizedBox(height: 3),

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
                                            style: style14,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Discount",
                                            style: style15.copyWith(
                                              color: secondaryColor,
                                            ),
                                          ),
                                          Text(
                                            "-\$ ${provider.discount.toStringAsFixed(2)}",
                                            style: style14.copyWith(
                                              color: Colors.green,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 3),

                                      Divider(),
                                      SizedBox(height: 3),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Total", style: style14),
                                          Text(
                                            "\$ ${provider.total.toStringAsFixed(2)}",
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(height: 50,),

                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) =>CheckOutScreen() ,));
                                  },

                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    foregroundColor: Colors.white,
                                    minimumSize: const Size(
                                      double.infinity,
                                      50,
                                    ),

                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),

                                  child: const Text(
                                    "Proceed to Checkout",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
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
