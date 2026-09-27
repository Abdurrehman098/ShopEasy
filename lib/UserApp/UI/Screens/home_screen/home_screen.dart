import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_easy/UserApp/UI/Screens/whishlist/wishlist_screen.dart';
import 'package:shop_easy/UserApp/UI/Widgets/productCard/product_card.dart';
import 'package:shop_easy/UserApp/core/constant/colors.dart';
import 'package:shop_easy/UserApp/core/constant/text_style.dart';
import 'package:shop_easy/UserApp/provider/product_view_model.dart';
import 'package:shop_easy/main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final provider = Provider.of<ProductViewModel>(
        navigatorKey.currentContext!,
        listen: false,
      );

      provider.getProducts();
      provider.getCategories();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductViewModel>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: backgroundColor,

          appBar: AppBar(
            toolbarHeight: 70,
            backgroundColor: whiteColor,
            elevation: 0,

            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),

              child: Row(
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    color: primaryColor,
                    size: 36,
                  ),

                  const SizedBox(width: 7),

                  Text(
                    "ShopEasy",
                    style: style28.copyWith(color: Colors.black),
                  ),

                  const Spacer(),

                  Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.black,
                    size: 30,
                  ),

                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WishlistScreen(),
                        ),
                      );
                    },

                    icon: const Icon(Icons.favorite_border, size: 36),
                  ),
                ],
              ),
            ),
          ),

          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    "Hello User",
                    style: style14.copyWith(fontWeight: FontWeight.normal),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    "Find Your Perfect Product",
                    style: style28.copyWith(fontSize: 24),
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller: searchController,

                    onChanged: (value) {
                      provider.searchProduct(value);
                    },

                    decoration: InputDecoration(
                      hintText: "Search Product...",

                      prefixIcon: Icon(
                        Icons.search,
                        color: secondaryColor,
                        size: 36,
                      ),

                      suffixIcon: provider.searchText.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                searchController.clear();

                                provider.searchProduct("");
                              },

                              icon: const Icon(Icons.close),
                            )
                          : null,

                      fillColor: whiteColor,
                      filled: true,

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),

                        borderSide: BorderSide(color: secondaryColor),
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),

                        borderSide: BorderSide(color: secondaryColor),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    height: 40,

                    child: provider.isLoadingCategories
                        ? const Center(child: CircularProgressIndicator())
                        : provider.categories.isEmpty
                        ? const Center(child: Text("No Categories Found"))
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,

                            itemCount: provider.categories.length + 1,

                            itemBuilder: (context, index) {
                              if (index == 0) {
                                const category = "All";

                                final isSelected =
                                    provider.selectedCategory == category;

                                return GestureDetector(
                                  onTap: () {
                                    provider.selectCategory("All");
                                  },

                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 8),

                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),

                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? primaryColor
                                            : whiteColor,

                                        borderRadius: BorderRadius.circular(20),

                                        border: Border.all(
                                          color: secondaryColor,
                                        ),
                                      ),

                                      child: Text(
                                        category,

                                        style: TextStyle(
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.black87,

                                          fontSize: 13,

                                          fontWeight: isSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }

                              final category = provider.categories[index - 1];

                              final isSelected =
                                  provider.selectedCategory.toLowerCase() ==
                                  category.category.toLowerCase();

                              return GestureDetector(
                                onTap: () {
                                  provider.selectCategory(category.category);
                                },

                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8),

                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),

                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? primaryColor
                                          : whiteColor,

                                      borderRadius: BorderRadius.circular(20),

                                      border: Border.all(color: secondaryColor),
                                    ),

                                    child: Text(
                                      category.name,

                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.black87,

                                        fontSize: 13,

                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),

                  const SizedBox(height: 15),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      const Text(
                        "Popular Products",

                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          provider.clearFilters();

                          searchController.clear();
                        },

                        child: Text(
                          "See All",

                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  provider.isLoadingProducts
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(30),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : provider.productError.isNotEmpty
                      ? Center(
                          child: Text(
                            provider.productError,

                            style: const TextStyle(color: Colors.red),
                          ),
                        )
                      : provider.filteredProducts.isEmpty
                      ? Center(
                          child: Text(
                            "No product found",

                            style: TextStyle(color: secondaryColor),
                          ),
                        )
                      : GridView.builder(
                          shrinkWrap: true,

                          physics: const NeverScrollableScrollPhysics(),

                          itemCount: provider.filteredProducts.length,

                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: 0.72,
                              ),

                          itemBuilder: (context, index) {
                            final product = provider.filteredProducts[index];

                            return ProductCard(product: product);
                          },
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
