import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_easy/AdminApp/UI/Screens/product/add_product.dart';
import 'package:shop_easy/AdminApp/UI/Screens/product/edit_product.dart';

import 'package:shop_easy/AdminApp/provider/admin_product_view_model.dart';
import 'package:shop_easy/UserApp/core/constant/colors.dart';
import 'package:shop_easy/UserApp/core/constant/text_style.dart';

class AdminProductsScreen extends StatefulWidget {
  const AdminProductsScreen({super.key});

  @override
  State<AdminProductsScreen> createState() => _AdminProductsScreenState();
}

class _AdminProductsScreenState extends State<AdminProductsScreen> {
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      Provider.of<AdminProductProvider>(context, listen: false).getProducts();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminProductProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: backgroundColor,

          appBar: AppBar(
            backgroundColor: whiteColor,
            elevation: 0,

            title: Text(
              "Products",
              style: style16.copyWith(
                fontWeight: FontWeight.bold,
                color: boldTextColor,
              ),
            ),

            actions: [
              IconButton(
                onPressed: () {
                  provider.getProducts();
                },

                icon: const Icon(Icons.refresh, color: Colors.black),
              ),
            ],
          ),

          body: Padding(
            padding: const EdgeInsets.all(16),

            child: Column(
              children: [
                // SEARCH
                TextField(
                  controller: searchController,

                  onChanged: (value) {
                    provider.searchProduct(value);
                  },

                  decoration: InputDecoration(
                    hintText: "Search products...",

                    prefixIcon: const Icon(Icons.search),

                    suffixIcon: provider.searchText.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              searchController.clear();

                              provider.searchProduct("");
                            },

                            icon: const Icon(Icons.close),
                          )
                        : null,

                    filled: true,
                    fillColor: whiteColor,

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),

                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // PRODUCT COUNT + ADD BUTTON
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Text(
                      "${provider.filteredProducts.length} Products",

                      style: style14.copyWith(color: secondaryColor),
                    ),

                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddProductScreen(),
                          ),
                        );
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: whiteColor,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),

                      icon: const Icon(Icons.add, size: 18),

                      label: const Text("Add Product"),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // PRODUCTS
                Expanded(
                  child: provider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : provider.filteredProducts.isEmpty
                      ? const Center(child: Text("No products found"))
                      : ListView.builder(
                          itemCount: provider.filteredProducts.length,

                          itemBuilder: (context, index) {
                            final product = provider.filteredProducts[index];

                            return _productCard(context, product, provider);
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

  Widget _productCard(
    BuildContext context,
    dynamic product,
    AdminProductProvider provider,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),

      padding: const EdgeInsets.all(10),

      decoration: BoxDecoration(
        color: whiteColor,

        borderRadius: BorderRadius.circular(12),
      ),

      child: Row(
        children: [
          // PRODUCT IMAGE
          Container(
            width: 65,
            height: 65,

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

          const SizedBox(width: 12),

          // PRODUCT INFORMATION
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

                const SizedBox(height: 4),

                Text(
                  product.category,

                  style: style15.copyWith(color: secondaryColor),
                ),

                const SizedBox(height: 5),

                Row(
                  children: [
                    Text(
                      "\$${product.price.toStringAsFixed(0)}",

                      style: style14.copyWith(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(width: 8),

                    const Icon(Icons.star, size: 15, color: Colors.orange),

                    const SizedBox(width: 3),

                    Text(product.rating.toStringAsFixed(1), style: style14),
                  ],
                ),
              ],
            ),
          ),

          // EDIT
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProductScreen(product: product),
                ),
              );
            },

            icon: const Icon(Icons.edit_outlined, size: 20),
          ),

          // DELETE
          IconButton(
            onPressed: () {
              _deleteProduct(context, product.id, provider);
            },

            icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
          ),
        ],
      ),
    );
  }

  void _deleteProduct(
    BuildContext context,
    String productId,
    AdminProductProvider provider,
  ) {
    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Product"),

          content: const Text("Are you sure you want to delete this product?"),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text("Cancel"),
            ),

            TextButton(
              onPressed: () async {
                Navigator.pop(context);

                await provider.deleteProduct(productId);
              },

              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
