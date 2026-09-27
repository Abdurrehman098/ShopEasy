import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_easy/AdminApp/provider/admin_category_view_model.dart';
import 'package:shop_easy/UserApp/core/constant/colors.dart';
import 'package:shop_easy/UserApp/core/constant/text_style.dart';
import 'package:shop_easy/UserApp/model/categorymodel/category_model.dart';

class AddCategoryScreen extends StatefulWidget {
  final CategoryModel? category;

  const AddCategoryScreen({
    super.key,
    this.category,
  });

  @override
  State<AddCategoryScreen> createState() =>
      _AddCategoryScreenState();
}

class _AddCategoryScreenState
    extends State<AddCategoryScreen> {
  final nameController =
  TextEditingController();

  final idController =
  TextEditingController();

  final imageController =
  TextEditingController();

  bool get isEdit =>
      widget.category != null;

  @override
  void initState() {
    super.initState();

    if (widget.category != null) {
      nameController.text =
          widget.category!.name;

      idController.text =
          widget.category!.category;

      imageController.text =
          widget.category!.image;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    idController.dispose();
    imageController.dispose();

    super.dispose();
  }

  Future<void> saveCategory() async {
    if (nameController.text
        .trim()
        .isEmpty) {
      _showError(
        "Please enter category name",
      );
      return;
    }

    if (idController.text
        .trim()
        .isEmpty) {
      _showError(
        "Please enter category ID",
      );
      return;
    }

    if (imageController.text
        .trim()
        .isEmpty) {
      _showError(
        "Please enter image path",
      );
      return;
    }

    final provider =
    Provider.of<AdminCategoryProvider>(
      context,
      listen: false,
    );

    final category = CategoryModel(
      id: isEdit
          ? widget.category!.id
          : DateTime.now()
          .millisecondsSinceEpoch
          .toString(),

      name: nameController.text.trim(),

      image: imageController.text.trim(),

      category: idController.text.trim(),
    );

    bool success;

    if (isEdit) {
      success = await provider.updateCategory(
        category,
      );
    } else {
      success = await provider.addCategory(
        category,
      );
    }

    if (!mounted) return;

    if (success) {
      Navigator.pop(context);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminCategoryProvider>(
      builder: (
          context,
          provider,
          child,
          ) {
        return Scaffold(
          backgroundColor: backgroundColor,

          appBar: AppBar(
            backgroundColor: whiteColor,
            elevation: 0,

            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },

              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),

            title: Text(
              isEdit
                  ? "Edit Category"
                  : "Add Category",

              style: style16.copyWith(
                fontWeight:
                FontWeight.bold,

                color: boldTextColor,
              ),
            ),
          ),

          body: SingleChildScrollView(
            padding:
            const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [
                _label(
                  "CATEGORY NAME",
                ),

                const SizedBox(
                  height: 6,
                ),

                TextField(
                  controller:
                  nameController,

                  decoration:
                  _inputDecoration(
                    "Category name",
                  ),
                ),

                const SizedBox(
                  height: 15,
                ),

                _label(
                  "CATEGORY ID",
                ),

                const SizedBox(
                  height: 6,
                ),

                TextField(
                  controller:
                  idController,

                  decoration:
                  _inputDecoration(
                    "Example: CAT-SH",
                  ),
                ),

                const SizedBox(
                  height: 15,
                ),

                _label(
                  "IMAGE PATH",
                ),

                const SizedBox(
                  height: 6,
                ),

                TextField(
                  controller:
                  imageController,

                  decoration:
                  _inputDecoration(
                    "assets/static_assets/category1.png",
                  ),
                ),

                const SizedBox(
                  height: 6,
                ),

                Text(
                  "Example: assets/static_assets/category1.png",

                  style: style15.copyWith(
                    fontSize: 12,
                    color: secondaryColor,
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                // IMAGE PREVIEW
                if (imageController
                    .text
                    .isNotEmpty)
                  Container(
                    width: double.infinity,
                    height: 130,

                    padding:
                    const EdgeInsets.all(
                      10,
                    ),

                    decoration:
                    BoxDecoration(
                      color: whiteColor,

                      borderRadius:
                      BorderRadius
                          .circular(
                        10,
                      ),
                    ),

                    child: Image.asset(
                      imageController.text,

                      fit: BoxFit.contain,

                      errorBuilder: (
                          context,
                          error,
                          stackTrace,
                          ) {
                        return const Center(
                          child: Text(
                            "Image preview not available",
                          ),
                        );
                      },
                    ),
                  ),

                const SizedBox(
                  height: 25,
                ),

                SizedBox(
                  width: double.infinity,
                  height: 50,

                  child:
                  ElevatedButton(
                    onPressed:
                    provider.isLoading
                        ? null
                        : saveCategory,

                    style:
                    ElevatedButton
                        .styleFrom(
                      backgroundColor:
                      primaryColor,

                      foregroundColor:
                      whiteColor,

                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius
                            .circular(
                          10,
                        ),
                      ),
                    ),

                    child: provider
                        .isLoading
                        ? const SizedBox(
                      width: 22,
                      height: 22,

                      child:
                      CircularProgressIndicator(
                        color:
                        Colors.white,

                        strokeWidth: 2,
                      ),
                    )
                        : Text(
                      isEdit
                          ? "Update Category"
                          : "Save Category",

                      style:
                      style16.copyWith(
                        color:
                        whiteColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _label(String text) {
    return Text(
      text,

      style: style14.copyWith(
        fontSize: 11,
        color: secondaryColor,
      ),
    );
  }

  InputDecoration _inputDecoration(
      String hint,
      ) {
    return InputDecoration(
      hintText: hint,

      filled: true,
      fillColor: whiteColor,

      border: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(10),

        borderSide: BorderSide(
          color: Colors.grey.shade300,
        ),
      ),

      enabledBorder:
      OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(10),

        borderSide: BorderSide(
          color: Colors.grey.shade300,
        ),
      ),

      focusedBorder:
      const OutlineInputBorder(
        borderRadius:
        BorderRadius.all(
          Radius.circular(10),
        ),

        borderSide: BorderSide(
          color: primaryColor,
        ),
      ),
    );
  }
}