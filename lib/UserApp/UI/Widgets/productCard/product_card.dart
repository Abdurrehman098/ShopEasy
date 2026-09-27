import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_easy/UserApp/UI/Screens/productDetailScreen/product_detail_screen.dart';
import 'package:shop_easy/UserApp/core/constant/colors.dart';
import 'package:shop_easy/UserApp/core/constant/text_style.dart';
import 'package:shop_easy/UserApp/model/productmodel/product_model.dart';
import 'package:shop_easy/UserApp/provider/product_view_model.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductViewModel>(
      builder: (context, provider, child) {
        final bool isFavorite = provider.isFavorite(product.id);

        final bool isInCart = provider.isInCart(product.id);

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailScreen(product: product),
              ),
            );
          },

          child: Container(
            padding: const EdgeInsets.all(8),

            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(12),

              border: Border.all(color: Colors.grey.shade300),
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),

                      child: Image.asset(
                        product.image,

                        width: double.infinity,
                        height: 100,

                        fit: BoxFit.cover,

                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 100,
                            width: double.infinity,

                            color: Colors.grey.shade100,

                            child: const Icon(
                              Icons.image_not_supported_outlined,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    ),

                    Positioned(
                      top: 6,
                      right: 6,

                      child: GestureDetector(
                        onTap: () async {
                          final user = FirebaseAuth.instance.currentUser;

                          if (user == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please login first"),
                              ),
                            );

                            return;
                          }

                          await provider.toggleFavorite(user.uid, product.id);
                        },

                        child: Container(
                          height: 30,
                          width: 30,

                          decoration: BoxDecoration(
                            color: whiteColor,
                            shape: BoxShape.circle,

                            boxShadow: [
                              BoxShadow(
                                color: Colors.black,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),

                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,

                            size: 17,

                            color: isFavorite ? Colors.red : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Text(
                  product.name,

                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,

                  style: style14.copyWith(fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 4),

                Row(
                  children: [
                    const Icon(Icons.star, size: 14, color: Colors.amber),

                    const SizedBox(width: 3),

                    Text(
                      product.rating.toString(),

                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Text(
                      "\$${product.price.toStringAsFixed(2)}",

                      style: const TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        provider.addToCart(product);

                        ScaffoldMessenger.of(context).hideCurrentSnackBar();

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isInCart
                                  ? "${product.name} quantity updated"
                                  : "${product.name} added to cart",
                            ),

                            backgroundColor: Colors.green,

                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },

                      child: Container(
                        height: 28,
                        width: 28,

                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(7),
                        ),

                        child: Icon(
                          isInCart ? Icons.shopping_cart : Icons.add,

                          color: whiteColor,
                          size: 17,
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
    );
  }
}
