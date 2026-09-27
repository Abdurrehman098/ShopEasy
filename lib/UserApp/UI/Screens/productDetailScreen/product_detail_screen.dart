import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_easy/UserApp/core/constant/colors.dart';
import 'package:shop_easy/UserApp/core/constant/text_style.dart';
import 'package:shop_easy/UserApp/model/productmodel/product_model.dart';
import 'package:shop_easy/UserApp/provider/product_view_model.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductViewModel>(
      builder: (context, provider, child) {
        final user = FirebaseAuth.instance.currentUser;

        final bool isFavorite = provider.isFavorite(product.id);
        final bool isInCart = provider.isInCart(product.id);

        final int quantity = isInCart ? provider.getQuantity(product.id) : 1;

        return Scaffold(
          backgroundColor: backgroundColor,

          appBar: AppBar(
            backgroundColor: backgroundColor,
            elevation: 0,

            title: const Text("Product Details"),

            actions: [
              IconButton(
                onPressed: () async {
                  if (user == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Please login to add products to wishlist",
                        ),
                      ),
                    );

                    return;
                  }

                  await provider.toggleFavorite(user.uid, product.id);

                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        provider.isFavorite(product.id)
                            ? "Added to wishlist"
                            : "Removed from wishlist",
                      ),
                    ),
                  );
                },

                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,

                  color: isFavorite ? Colors.red : secondaryColor,
                ),
              ),
            ],
          ),

          body: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(
                  product.image,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),

                Container(
                  width: double.infinity,

                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    color: whiteColor,

                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Expanded(
                            child: Text(
                              product.name,

                              style: style16.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),

                              maxLines: 2,

                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          const SizedBox(width: 15),

                          Text(
                            "\$ ${product.price.toStringAsFixed(2)}",

                            style: style16.copyWith(
                              color: primaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),

                          const SizedBox(width: 4),

                          Text(
                            product.rating.toString(),
                            style: style14.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      Divider(color: Colors.grey.shade300),

                      const SizedBox(height: 10),

                      Text(
                        "Description",

                        style: style16.copyWith(fontWeight: FontWeight.w800),
                      ),

                      const SizedBox(height: 7),

                      Text(
                        product.description,

                        style: TextStyle(color: secondaryColor, height: 1.5),
                      ),

                      const SizedBox(height: 15),

                      Divider(color: Colors.grey.shade300),

                      const SizedBox(height: 15),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          Text(
                            "Quantity",

                            style: style16.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),

                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xffF7F7F9),

                              borderRadius: BorderRadius.circular(8),
                            ),

                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    if (!isInCart) {
                                      return;
                                    }

                                    provider.decreaseQuantity(product.id);
                                  },

                                  icon: const Icon(Icons.remove),
                                ),

                                Text(
                                  quantity.toString(),

                                  style: style14.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                IconButton(
                                  onPressed: () {
                                    if (!isInCart) {
                                      return;
                                    }

                                    provider.increaseQuantity(product.id);
                                  },

                                  icon: const Icon(Icons.add),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(20),

                  child: SizedBox(
                    width: double.infinity,
                    height: 60,

                    child: ElevatedButton(
                      onPressed: () {
                        if (!isInCart) {
                          provider.addToCart(product);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Product added to cart"),

                              backgroundColor: Colors.green,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Product is already in cart"),
                            ),
                          );
                        }
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: whiteColor,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          Icon(
                            isInCart
                                ? Icons.check
                                : Icons.shopping_cart_outlined,

                            color: whiteColor,
                            size: 20,
                          ),

                          const SizedBox(width: 8),

                          Text(
                            isInCart ? "Added to Cart" : "Add To Cart",

                            style: style16.copyWith(
                              color: whiteColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }
}
