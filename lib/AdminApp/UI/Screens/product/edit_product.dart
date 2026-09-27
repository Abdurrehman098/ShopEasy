import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_easy/AdminApp/provider/admin_product_view_model.dart';
import 'package:shop_easy/UserApp/core/constant/colors.dart';
import 'package:shop_easy/UserApp/core/constant/text_style.dart';
import 'package:shop_easy/UserApp/model/productmodel/product_model.dart';

class EditProductScreen extends StatefulWidget {
  final ProductModel product;

  const EditProductScreen({super.key, required this.product});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  late TextEditingController nameController;
  late TextEditingController imageController;
  late TextEditingController categoryController;
  late TextEditingController descriptionController;
  late TextEditingController priceController;
  late TextEditingController ratingController;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.product.name);

    imageController = TextEditingController(text: widget.product.image);

    categoryController = TextEditingController(text: widget.product.category);

    descriptionController = TextEditingController(
      text: widget.product.description,
    );

    priceController = TextEditingController(
      text: widget.product.price.toString(),
    );

    ratingController = TextEditingController(
      text: widget.product.rating.toString(),
    );
  }

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

  Future<void> updateProduct() async {
    // PRODUCT NAME
    if (nameController.text.trim().isEmpty) {
      _showError("Please enter product name");
      return;
    }

    // IMAGE PATH
    if (imageController.text.trim().isEmpty) {
      _showError("Please enter image path");
      return;
    }

    // CATEGORY
    if (categoryController.text.trim().isEmpty) {
      _showError("Please enter category");
      return;
    }

    // DESCRIPTION
    if (descriptionController.text.trim().isEmpty) {
      _showError("Please enter description");
      return;
    }

    // PRICE
    if (priceController.text.trim().isEmpty) {
      _showError("Please enter price");
      return;
    }

    // RATING
    if (ratingController.text.trim().isEmpty) {
      _showError("Please enter rating");
      return;
    }

    final price = double.tryParse(priceController.text.trim());

    final rating = double.tryParse(ratingController.text.trim());

    if (price == null) {
      _showError("Please enter a valid price");
      return;
    }

    if (rating == null) {
      _showError("Please enter a valid rating");
      return;
    }

    if (rating < 0 || rating > 5) {
      _showError("Rating must be between 0 and 5");
      return;
    }

    final updatedProduct = ProductModel(
      id: widget.product.id,

      name: nameController.text.trim(),

      image: imageController.text.trim(),

      category: categoryController.text.trim(),

      description: descriptionController.text.trim(),

      price: price,

      rating: rating,

      // Original createdAt same rahega
      createdAt: widget.product.createdAt,
    );

    final provider = Provider.of<AdminProductProvider>(context, listen: false);

    final success = await provider.updateProduct(updatedProduct);

    if (!mounted) return;

    if (success) {
      Navigator.pop(context);
    }
  }

  void _showError(String message) {
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
              "Edit Product",
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
                _title("PRODUCT NAME"),

                const SizedBox(height: 6),

                TextField(
                  controller: nameController,

                  decoration: _inputDecoration("Product name"),
                ),

                const SizedBox(height: 15),

                // IMAGE PATH
                _title("IMAGE PATH"),

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
                _title("CATEGORY"),

                const SizedBox(height: 6),

                TextField(
                  controller: categoryController,

                  decoration: _inputDecoration("Category"),
                ),

                const SizedBox(height: 15),

                // DESCRIPTION
                _title("DESCRIPTION"),

                const SizedBox(height: 6),

                TextField(
                  controller: descriptionController,

                  maxLines: 4,

                  decoration: _inputDecoration("Product description"),
                ),

                const SizedBox(height: 15),

                // PRICE + RATING
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          _title("PRICE"),

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
                          _title("RATING"),

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

                // UPDATE BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 50,

                  child: ElevatedButton(
                    onPressed: provider.isLoading ? null : updateProduct,

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
                            "Update Product",
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

  Widget _title(String text) {
    return Text(
      text,

      style: style14.copyWith(fontSize: 11, color: secondaryColor),
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
