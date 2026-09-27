import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_easy/AdminApp/UI/utills/show_message.dart';
import 'package:shop_easy/UserApp/model/categorymodel/category_model.dart';

class AdminCategoryProvider extends ChangeNotifier {
  final FirebaseFirestore firestore =
      FirebaseFirestore.instance;

  List<CategoryModel> categories = [];

  bool isLoading = false;

  String error = "";

  String searchText = "";

  List<CategoryModel> get filteredCategories {
    if (searchText.isEmpty) {
      return categories;
    }

    return categories.where((category) {
      return category.name
          .toLowerCase()
          .contains(searchText.toLowerCase());
    }).toList();
  }

  // GET CATEGORIES
  Future<void> getCategories() async {
    try {
      isLoading = true;
      error = "";

      notifyListeners();

      final snapshot = await firestore
          .collection("categories")
          .get();

      categories = snapshot.docs.map((doc) {
        final data = doc.data();

        return CategoryModel.fromMap({
          ...data,
          "id": doc.id,
        });
      }).toList();

    } catch (e) {
      error = "Failed to load categories";

      print("Category Error: $e");
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }

  // SEARCH CATEGORY
  void searchCategory(String value) {
    searchText = value;

    notifyListeners();
  }

  // ADD CATEGORY
  Future<bool> addCategory(
      CategoryModel category,
      ) async {
    try {
      isLoading = true;
      error = "";

      notifyListeners();

      await firestore
          .collection("categories")
          .doc(category.id)
          .set(category.toMap());

      await getCategories();

      showMsg(
        "Category added successfully",
        false,
      );

      return true;
    } catch (e) {
      error = "Failed to add category";

      showMsg(
        "Failed to add category",
      );

      return false;
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }

  // UPDATE CATEGORY
  Future<bool> updateCategory(
      CategoryModel category,
      ) async {
    try {
      isLoading = true;
      error = "";

      notifyListeners();

      await firestore
          .collection("categories")
          .doc(category.id)
          .update(category.toMap());

      await getCategories();

      showMsg(
        "Category updated successfully",
        false,
      );

      return true;
    } catch (e) {
      error = "Failed to update category";

      showMsg(
        "Failed to update category",
      );

      return false;
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }

  // DELETE CATEGORY
  Future<bool> deleteCategory(
      String id,
      ) async {
    try {
      isLoading = true;
      error = "";

      notifyListeners();

      await firestore
          .collection("categories")
          .doc(id)
          .delete();

      categories.removeWhere(
            (category) => category.id == id,
      );

      showMsg(
        "Category deleted",
        false,
      );

      return true;
    } catch (e) {
      error = "Failed to delete category";

      showMsg(
        "Failed to delete category",
      );

      return false;
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }
}