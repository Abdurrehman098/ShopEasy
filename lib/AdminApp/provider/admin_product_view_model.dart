import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_easy/AdminApp/UI/utills/show_message.dart';
import 'package:shop_easy/UserApp/model/productmodel/product_model.dart';

class AdminProductProvider extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  bool isLoading = false;

  String searchText = "";

  List<ProductModel> products = [];

  List<ProductModel> filteredProducts = [];

  Future<void> getProducts() async {
    try {
      isLoading = true;

      notifyListeners();

      final snapshot = await firestore.collection("products").get();

      products = snapshot.docs.map((doc) {
        final data = doc.data();

        return ProductModel.fromMap(data);
      }).toList();

      filteredProducts = products;
    } catch (e) {
      showMsg("Unable to load products");
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }

  void searchProduct(String value) {
    searchText = value;

    if (value.isEmpty) {
      filteredProducts = products;

      notifyListeners();

      return;
    }

    filteredProducts = products.where((product) {
      return product.name.toLowerCase().contains(value.toLowerCase());
    }).toList();

    notifyListeners();
  }

  Future<bool> addProduct(ProductModel product) async {
    try {
      isLoading = true;

      notifyListeners();

      await firestore
          .collection("products")
          .doc(product.id)
          .set(product.toMap());

      products.add(product);

      searchProduct(searchText);

      showMsg("Product added successfully", false);

      return true;
    } catch (e) {
      showMsg("Unable to add product");

      return false;
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }

  Future<bool> updateProduct(ProductModel product) async {
    try {
      isLoading = true;

      notifyListeners();

      await firestore.collection("products").doc(product.id).update({
        "name": product.name,
        "image": product.image,
        "category": product.category,
        "description": product.description,
        "price": product.price,
        "rating": product.rating,
      });

      final index = products.indexWhere((item) => item.id == product.id);

      if (index != -1) {
        products[index] = product;
      }

      searchProduct(searchText);

      showMsg("Product updated successfully", false);

      return true;
    } catch (e) {
      showMsg("Unable to update product");

      return false;
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }

  Future<bool> deleteProduct(String productId) async {
    try {
      isLoading = true;

      notifyListeners();

      await firestore.collection("products").doc(productId).delete();

      products.removeWhere((product) => product.id == productId);

      filteredProducts.removeWhere((product) => product.id == productId);

      showMsg("Product deleted successfully", false);

      return true;
    } catch (e) {
      showMsg("Unable to delete product");

      return false;
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }

  void clearSearch() {
    searchText = "";

    filteredProducts = products;

    notifyListeners();
  }
}
