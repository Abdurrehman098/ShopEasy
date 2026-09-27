import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_easy/UserApp/UI/Screens/categories/productListing/product_listing.dart';
import 'package:shop_easy/UserApp/core/constant/colors.dart';
import 'package:shop_easy/UserApp/core/constant/text_style.dart';
import 'package:shop_easy/UserApp/provider/product_view_model.dart';
import 'package:shop_easy/main.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider = Provider.of<ProductViewModel>(
        navigatorKey.currentContext!,
        listen: false,
      );
      if (provider.categories.isEmpty) {
        provider.getCategories();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductViewModel>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 70,
            backgroundColor: whiteColor,
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  // IconButton(
                  //   onPressed: () {
                  //     if (Navigator.canPop(context)) {
                  //       Navigator.pop(context);
                  //     }
                  //   },
                  //   icon: Icon(Icons.arrow_back_outlined),
                  // ),
                  SizedBox(width: 7),
                  Text(
                    "Categories",
                    style: style28.copyWith(color: Colors.black),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),

          body: provider.isLoadingCategories
              ? const Center(child: CircularProgressIndicator())
              : provider.categoryError.isNotEmpty
              ? Center(
                  child: Text(
                    provider.categoryError,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                )
              : provider.categories.isEmpty
              ? const Center(child: Text("No categories found"))
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: GridView.builder(
                    itemCount: provider.categories.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.12,
                    ),
                    itemBuilder: (context, index) {
                      final category = provider.categories[index];
                      return GestureDetector(
                        onTap: () {
                          provider.selectCategory(category.category);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductListing(
                                categoryName: category.category,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade700,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  category.image,
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,

                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(
                                      child: Icon(
                                        Icons.image_not_supported,
                                        size: 50,
                                        color: Colors.grey,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Positioned(
                                left: 12,
                                bottom: 12,
                                child: Text(
                                  category.name,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: whiteColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
        );
      },
    );
  }
}
