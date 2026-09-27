import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_easy/UserApp/UI/Widgets/productCard/product_card.dart';
import 'package:shop_easy/UserApp/core/constant/colors.dart';
import 'package:shop_easy/UserApp/core/constant/text_style.dart';
import 'package:shop_easy/UserApp/model/productmodel/product_model.dart';
import 'package:shop_easy/UserApp/provider/product_view_model.dart';

class ProductListing extends StatelessWidget {
  final String categoryName;

  const ProductListing({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductViewModel>(
      builder: (context, provider, child) {
        final products = provider.filteredProducts;

        return Scaffold(
          backgroundColor: backgroundColor,

          appBar: AppBar(
            backgroundColor: whiteColor,
            elevation: 0,
            scrolledUnderElevation: 0,
            toolbarHeight: 65,
            automaticallyImplyLeading: false,

            title: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.black,
                    size: 18,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    categoryName.isEmpty ? "Products" : categoryName,
                    style: style28.copyWith(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                IconButton(
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: ProductSearchDelegate(products: products),
                    );
                  },
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.search, color: Colors.black, size: 25),
                ),
              ],
            ),
          ),

          body: Column(
            children: [
              // Sort & Filter
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 5,
                ),

                child: Row(
                  children: [
                    // Sort
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          _showSortBottomSheet(context, provider);
                        },

                        child: Container(
                          height: 36,

                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(color: const Color(0xffE3E3E8)),
                          ),

                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: [
                              Icon(
                                Icons.sort,
                                size: 15,
                                color: Color(0xff777777),
                              ),

                              SizedBox(width: 6),

                              Text(
                                "Sort",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xff777777),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    // Filter
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          _showFilterBottomSheet(context, provider);
                        },

                        child: Container(
                          height: 36,

                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(color: const Color(0xffE3E3E8)),
                          ),

                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: [
                              Icon(
                                Icons.tune,
                                size: 15,
                                color: Color(0xff777777),
                              ),

                              SizedBox(width: 6),

                              Text(
                                "Filter",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xff777777),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 5),

              // Products
              Expanded(
                child: products.isEmpty
                    ? const Center(
                        child: Text(
                          "No products found",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),

                        itemCount: products.length,

                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 0.72,
                            ),

                        itemBuilder: (context, index) {
                          return ProductCard(product: products[index]);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSortBottomSheet(BuildContext context, ProductViewModel provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: whiteColor,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),

      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              const Padding(
                padding: EdgeInsets.all(18),

                child: Text(
                  "Sort By",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),

              // Default
              ListTile(
                leading: const Icon(Icons.sort),

                title: const Text("Default"),

                trailing: provider.selectedSort == "Default"
                    ? Icon(Icons.check, color: primaryColor)
                    : null,

                onTap: () {
                  provider.selectSort("Default");

                  Navigator.pop(context);
                },
              ),

              // Low to High
              ListTile(
                leading: const Icon(Icons.arrow_upward),

                title: const Text("Price : Low to High"),

                trailing: provider.selectedSort == "price : Low to High"
                    ? Icon(Icons.check, color: primaryColor)
                    : null,

                onTap: () {
                  provider.selectSort("price : Low to High");

                  Navigator.pop(context);
                },
              ),

              // High to Low
              ListTile(
                leading: const Icon(Icons.arrow_downward),

                title: const Text("Price : High to Low"),

                trailing: provider.selectedSort == "price : High to Low"
                    ? Icon(Icons.check, color: primaryColor)
                    : null,

                onTap: () {
                  provider.selectSort("price : High to Low");

                  Navigator.pop(context);
                },
              ),

              // Rating
              ListTile(
                leading: const Icon(Icons.star_border),

                title: const Text("Rating"),

                trailing: provider.selectedSort == "Rating"
                    ? Icon(Icons.check, color: primaryColor)
                    : null,

                onTap: () {
                  provider.selectSort("Rating");

                  Navigator.pop(context);
                },
              ),

              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  void _showFilterBottomSheet(BuildContext context, ProductViewModel provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: whiteColor,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),

      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              const Padding(
                padding: EdgeInsets.all(18),

                child: Text(
                  "Filter By Category",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),

              // All
              ListTile(
                leading: const Icon(Icons.grid_view),

                title: const Text("All"),

                trailing: provider.selectedCategory == "All"
                    ? Icon(Icons.check, color: primaryColor)
                    : null,

                onTap: () {
                  provider.selectCategory("All");

                  Navigator.pop(context);
                },
              ),

              // Categories
              ...provider.categories.map((category) {
                final isSelected =
                    provider.selectedCategory.toLowerCase() ==
                    category.category.toLowerCase();

                return ListTile(
                  leading: const Icon(Icons.category_outlined),

                  title: Text(category.name),

                  trailing: isSelected
                      ? Icon(Icons.check, color: primaryColor)
                      : null,

                  onTap: () {
                    provider.selectCategory(category.category);

                    Navigator.pop(context);
                  },
                );
              }),

              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}

class ProductSearchDelegate extends SearchDelegate {
  final List<ProductModel> products;

  ProductSearchDelegate({required this.products});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          onPressed: () {
            query = "";
          },

          icon: const Icon(Icons.clear),
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },

      icon: const Icon(Icons.arrow_back),
    );
  }

  List<ProductModel> searchProducts() {
    final searchQuery = query.trim().toLowerCase();

    if (searchQuery.isEmpty) {
      return products;
    }

    return products.where((product) {
      final productName = product.name.trim().toLowerCase();

      final productCategory = product.category.trim().toLowerCase();

      final productDescription = product.description.trim().toLowerCase();

      return productName.contains(searchQuery) ||
          productCategory.contains(searchQuery) ||
          productDescription.contains(searchQuery);
    }).toList();
  }

  @override
  Widget buildResults(BuildContext context) {
    final result = searchProducts();

    return _buildSearchGrid(result);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final result = searchProducts();

    return _buildSearchGrid(result);
  }

  Widget _buildSearchGrid(List<ProductModel> result) {
    return Container(
      color: const Color(0xffF8F8FA),

      child: result.isEmpty
          ? const Center(
              child: Text(
                "No products found",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(20),

              itemCount: result.length,

              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.72,
              ),

              itemBuilder: (context, index) {
                return ProductCard(product: result[index]);
              },
            ),
    );
  }
}
