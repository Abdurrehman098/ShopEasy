import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_easy/AdminApp/UI/Screens/category/add_category.dart';
import 'package:shop_easy/AdminApp/provider/admin_category_view_model.dart';
import 'package:shop_easy/UserApp/core/constant/colors.dart';
import 'package:shop_easy/UserApp/core/constant/text_style.dart';
import 'package:shop_easy/UserApp/model/categorymodel/category_model.dart';

class AdminCategoriesScreen extends StatefulWidget {
  const AdminCategoriesScreen({super.key});

  @override
  State<AdminCategoriesScreen> createState() => _AdminCategoriesScreenState();
}

class _AdminCategoriesScreenState extends State<AdminCategoriesScreen> {
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminCategoryProvider>().getCategories();
    });
  }

  @override
  void dispose() {
    searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminCategoryProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: backgroundColor,

          appBar: AppBar(
            backgroundColor: whiteColor,
            elevation: 0,

            title: Text(
              "Categories",
              style: style16.copyWith(
                fontWeight: FontWeight.bold,
                color: boldTextColor,
              ),
            ),

            actions: [
              IconButton(
                onPressed: () {
                  provider.getCategories();
                },
                icon: const Icon(Icons.refresh, color: Colors.black),
              ),

              Padding(
                padding: const EdgeInsets.only(right: 10),

                child: ElevatedButton.icon(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddCategoryScreen(),
                      ),
                    );

                    if (result == true) {
                      provider.getCategories();
                    }
                  },

                  icon: const Icon(Icons.add, size: 16),

                  label: const Text("Add Category"),

                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,

                    foregroundColor: whiteColor,

                    elevation: 0,

                    padding: const EdgeInsets.symmetric(horizontal: 10),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),

          body: Padding(
            padding: const EdgeInsets.all(16),

            child: Column(
              children: [
                TextField(
                  controller: searchController,

                  onChanged: (value) {
                    provider.searchCategory(value);
                  },

                  decoration: InputDecoration(
                    hintText: "Search categories...",

                    prefixIcon: const Icon(Icons.search),

                    suffixIcon: provider.searchText.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              searchController.clear();

                              provider.searchCategory("");
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

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Text(
                      "${provider.filteredCategories.length} Categories",

                      style: style14.copyWith(color: secondaryColor),
                    ),

                    if (provider.searchText.isNotEmpty)
                      Text(
                        "Searching...",

                        style: style15.copyWith(color: secondaryColor),
                      ),
                  ],
                ),

                const SizedBox(height: 10),

                Expanded(
                  child: provider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : provider.error.isNotEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: [
                              Text(
                                provider.error,

                                style: const TextStyle(color: Colors.red),
                              ),

                              const SizedBox(height: 10),

                              ElevatedButton(
                                onPressed: () {
                                  provider.getCategories();
                                },

                                child: const Text("Try Again"),
                              ),
                            ],
                          ),
                        )
                      : provider.filteredCategories.isEmpty
                      ? const Center(child: Text("No categories found"))
                      : ListView.builder(
                          itemCount: provider.filteredCategories.length,

                          itemBuilder: (context, index) {
                            final category = provider.filteredCategories[index];

                            return _categoryCard(context, category, provider);
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

  Widget _categoryCard(
    BuildContext context,
    CategoryModel category,
    AdminCategoryProvider provider,
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
          Container(
            width: 55,
            height: 55,

            padding: const EdgeInsets.all(5),

            decoration: BoxDecoration(
              color: backgroundColor,

              borderRadius: BorderRadius.circular(8),
            ),

            child: Image.asset(
              category.image,

              fit: BoxFit.cover,

              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.image_not_supported,
                  color: Colors.grey,
                );
              },
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  category.name,

                  maxLines: 1,

                  overflow: TextOverflow.ellipsis,

                  style: style14.copyWith(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 4),

                Text(
                  category.category,

                  maxLines: 1,

                  overflow: TextOverflow.ellipsis,

                  style: style15.copyWith(fontSize: 12, color: secondaryColor),
                ),

                const SizedBox(height: 3),
              ],
            ),
          ),

          IconButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddCategoryScreen(category: category),
                ),
              );

              if (result == true) {
                provider.getCategories();
              }
            },

            icon: const Icon(Icons.edit_outlined, size: 20),
          ),

          // DELETE
          IconButton(
            onPressed: () {
              _deleteCategory(context, category.id, provider);
            },

            icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
          ),
        ],
      ),
    );
  }

  void _deleteCategory(
    BuildContext context,
    String id,
    AdminCategoryProvider provider,
  ) {
    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Category"),

          content: const Text("Are you sure you want to delete this category?"),

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

                await provider.deleteCategory(id);
              },

              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
