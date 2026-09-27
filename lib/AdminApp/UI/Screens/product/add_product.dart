import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_easy/AdminApp/provider/admin_product_view_model.dart';
import 'package:shop_easy/UserApp/core/constant/colors.dart';
import 'package:shop_easy/UserApp/core/constant/text_style.dart';
import 'package:shop_easy/UserApp/model/productmodel/product_model.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final nameController = TextEditingController();
  final imageController = TextEditingController();
  final categoryController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final ratingController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    imageController.dispose();
    categoryController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    ratingController.dispose();

    super.dispose();
  }

  Future<void> addProduct() async {
    // Name
    if (nameController.text.trim().isEmpty) {
      _showMessage("Please enter product name");
      return;
    }

    // Image
    if (imageController.text.trim().isEmpty) {
      _showMessage("Please enter image path");
      return;
    }

    // Category
    if (categoryController.text.trim().isEmpty) {
      _showMessage("Please enter category");
      return;
    }

    // Description
    if (descriptionController.text.trim().isEmpty) {
      _showMessage("Please enter description");
      return;
    }

    // Price
    if (priceController.text.trim().isEmpty) {
      _showMessage("Please enter price");
      return;
    }

    // Rating
    if (ratingController.text.trim().isEmpty) {
      _showMessage("Please enter rating");
      return;
    }

    final price = double.tryParse(priceController.text.trim());

    final rating = double.tryParse(ratingController.text.trim());

    if (price == null) {
      _showMessage("Please enter a valid price");
      return;
    }

    if (rating == null) {
      _showMessage("Please enter a valid rating");
      return;
    }

    if (rating < 0 || rating > 5) {
      _showMessage("Rating must be between 0 and 5");
      return;
    }

    final productId = DateTime.now().millisecondsSinceEpoch.toString();

    final product = ProductModel(
      id: productId,
      name: nameController.text.trim(),
      image: imageController.text.trim(),
      category: categoryController.text.trim(),
      description: descriptionController.text.trim(),
      price: price,
      rating: rating,
      createdAt: DateTime.now(),
    );

    final provider = Provider.of<AdminProductProvider>(context, listen: false);

    final success = await provider.addProduct(product);

    if (!mounted) return;

    if (success) {
      Navigator.pop(context);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
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

            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },

              icon: const Icon(Icons.arrow_back, color: Colors.black),
            ),

            title: Text(
              "Add Product",
              style: style16.copyWith(
                color: boldTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                // PRODUCT NAME
                Text(
                  "PRODUCT NAME",
                  style: style14.copyWith(fontSize: 11, color: secondaryColor),
                ),

                const SizedBox(height: 6),

                TextField(
                  controller: nameController,
                  decoration: _inputDecoration("Enter product name"),
                ),

                const SizedBox(height: 15),

                // IMAGE PATH
                Text(
                  "IMAGE PATH",
                  style: style14.copyWith(fontSize: 11, color: secondaryColor),
                ),

                const SizedBox(height: 6),

                TextField(
                  controller: imageController,

                  decoration: _inputDecoration(
                    "assets/static_assets/product.png",
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  "Example: assets/static_assets/blackSneaker.png",

                  style: style15.copyWith(fontSize: 12, color: secondaryColor),
                ),

                const SizedBox(height: 15),

                // CATEGORY
                Text(
                  "CATEGORY",
                  style: style14.copyWith(fontSize: 11, color: secondaryColor),
                ),

                const SizedBox(height: 6),

                TextField(
                  controller: categoryController,

                  decoration: _inputDecoration("Enter category"),
                ),

                const SizedBox(height: 15),

                // DESCRIPTION
                Text(
                  "DESCRIPTION",
                  style: style14.copyWith(fontSize: 11, color: secondaryColor),
                ),

                const SizedBox(height: 6),

                TextField(
                  controller: descriptionController,

                  maxLines: 4,

                  decoration: _inputDecoration("Enter product description"),
                ),

                const SizedBox(height: 15),

                // PRICE + RATING
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            "PRICE",
                            style: style14.copyWith(
                              fontSize: 11,
                              color: secondaryColor,
                            ),
                          ),

                          const SizedBox(height: 6),

                          TextField(
                            controller: priceController,

                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),

                            decoration: _inputDecoration("Price"),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            "RATING",
                            style: style14.copyWith(
                              fontSize: 11,
                              color: secondaryColor,
                            ),
                          ),

                          const SizedBox(height: 6),

                          TextField(
                            controller: ratingController,

                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),

                            decoration: _inputDecoration("0 - 5"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                // ADD BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 50,

                  child: ElevatedButton(
                    onPressed: provider.isLoading ? null : addProduct,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: whiteColor,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                    child: provider.isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,

                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            "Add Product",
                            style: style16.copyWith(color: whiteColor),
                          ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,

      filled: true,
      fillColor: whiteColor,

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),

        borderSide: BorderSide(color: Colors.grey.shade300),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),

        borderSide: BorderSide(color: Colors.grey.shade300),
      ),

      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),

        borderSide: BorderSide(color: primaryColor),
      ),
    );
  }
}
