import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_easy/UserApp/UI/Screens/cart/cart_screen.dart';
import 'package:shop_easy/UserApp/UI/Screens/categories/categories_screen.dart';
import 'package:shop_easy/UserApp/UI/Screens/home_screen/home_screen.dart';
import 'package:shop_easy/UserApp/UI/Screens/profile/profile_screen.dart';
import 'package:shop_easy/UserApp/UI/Screens/whishlist/wishlist_screen.dart';
import 'package:shop_easy/UserApp/model/categoryModel/category_model.dart';
import 'package:shop_easy/UserApp/model/orderModel/order_model.dart';
import 'package:shop_easy/UserApp/model/productmodel/product_model.dart';

class ProductViewModel extends ChangeNotifier {
  final FirebaseFirestore db = FirebaseFirestore.instance;



  int currentIndex = 0;

  void onClick(int index) {
    currentIndex = index;
    notifyListeners();
  }



  List<ProductModel> products = [];

  bool isLoadingProducts = false;
  String productError = "";

  Future<void> getProducts() async {
    try {
      isLoadingProducts = true;
      productError = "";
      notifyListeners();

      final snapshot = await db.collection("products").get();

      products = snapshot.docs.map((doc) {
        return ProductModel.fromMap(doc.data());
      }).toList();
    } catch (e) {
      productError = e.toString();
      debugPrint("Products Error: $e");
    } finally {
      isLoadingProducts = false;
      notifyListeners();
    }
  }

  List<ProductModel> getProductsByCategory(String category) {
    return products.where((product) {
      return product.category.toLowerCase() == category.toLowerCase();
    }).toList();
  }



  List<CategoryModel> categories = [];

  bool isLoadingCategories = false;
  String categoryError = "";

  Future<void> getCategories() async {
    try {
      isLoadingCategories = true;
      categoryError = "";
      notifyListeners();

      final snapshot = await db.collection("categories").get();

      categories = snapshot.docs.map((doc) {
        return CategoryModel.fromMap(doc.data());
      }).toList();
    } catch (e) {
      categoryError = e.toString();
      debugPrint("Categories Error: $e");
    } finally {
      isLoadingCategories = false;
      notifyListeners();
    }
  }



  String searchText = "";
  String selectedCategory = "All";
  String selectedSort = "Default";

  List<ProductModel> get filteredProducts {
    List<ProductModel> result = List.from(products);

    // Category filter
    if (selectedCategory != "All") {
      result = result.where((product) {
        return product.category.toLowerCase() ==
            selectedCategory.toLowerCase();
      }).toList();
    }

    // Search
    if (searchText.isNotEmpty) {
      result = result.where((product) {
        return product.name.toLowerCase().contains(
          searchText.toLowerCase(),
        );
      }).toList();
    }

    // Sorting
    if (selectedSort == "price : Low to High") {
      result.sort(
            (a, b) => a.price.compareTo(b.price),
      );
    } else if (selectedSort == "price : High to Low") {
      result.sort(
            (a, b) => b.price.compareTo(a.price),
      );
    } else if (selectedSort == "Rating") {
      result.sort(
            (a, b) => b.rating.compareTo(a.rating),
      );
    }

    return result;
  }

  void searchProduct(String value) {
    searchText = value;
    notifyListeners();
  }

  void selectCategory(String category) {
    selectedCategory = category;
    notifyListeners();
  }

  void selectSort(String sort) {
    selectedSort = sort;
    notifyListeners();
  }

  void clearFilters() {
    searchText = "";
    selectedCategory = "All";
    selectedSort = "Default";

    notifyListeners();
  }



  List<String> favoriteProducts = [];

  bool isFavorite(String productId) {
    return favoriteProducts.contains(productId);
  }

  Future<void> getWishlist(String userId) async {
    try {
      final doc = await db.collection("users").doc(userId).get();

      if (!doc.exists) {
        favoriteProducts = [];
        notifyListeners();
        return;
      }

      final data = doc.data();

      final wishlistData = data?["wishlist"];

      if (wishlistData is List) {
        favoriteProducts = wishlistData
            .map((item) => item.toString())
            .toList();
      } else {
        favoriteProducts = [];
      }

      notifyListeners();
    } catch (e) {
      debugPrint("Get Wishlist Error: $e");
    }
  }

  Future<void> toggleFavorite(
      String userId,
      String productId,
      ) async {
    try {
      final userRef = db.collection("users").doc(userId);

      if (favoriteProducts.contains(productId)) {
        favoriteProducts.remove(productId);

        await userRef.set(
          {
            "wishlist": FieldValue.arrayRemove([productId]),
          },
          SetOptions(merge: true),
        );
      } else {
        favoriteProducts.add(productId);

        await userRef.set(
          {
            "wishlist": FieldValue.arrayUnion([productId]),
          },
          SetOptions(merge: true),
        );
      }

      notifyListeners();
    } catch (e) {
      debugPrint("Toggle Wishlist Error: $e");
    }
  }

  List<ProductModel> get wishlistProducts {
    return products.where((product) {
      return favoriteProducts.contains(product.id);
    }).toList();
  }


  final List<ProductModel> cartProducts = [];

  final Map<String, int> cartQuantity = {};

  void addToCart(ProductModel product) {
    final exists = cartProducts.any(
          (item) => item.id == product.id,
    );

    if (!exists) {
      cartProducts.add(product);
      cartQuantity[product.id] = 1;
    }

    notifyListeners();
  }

  bool isInCart(String productId) {
    return cartProducts.any(
          (product) => product.id == productId,
    );
  }

  void removeFromCart(ProductModel product) {
    cartProducts.removeWhere(
          (item) => item.id == product.id,
    );

    cartQuantity.remove(product.id);

    notifyListeners();
  }

  int getQuantity(String productId) {
    return cartQuantity[productId] ?? 1;
  }

  void increaseQuantity(String productId) {
    cartQuantity[productId] =
        (cartQuantity[productId] ?? 1) + 1;

    notifyListeners();
  }

  void decreaseQuantity(String productId) {
    final quantity = cartQuantity[productId] ?? 1;

    if (quantity > 1) {
      cartQuantity[productId] = quantity - 1;
    }

    notifyListeners();
  }



  double get subtotal {
    double total = 0;

    for (final product in cartProducts) {
      final quantity = cartQuantity[product.id] ?? 1;

      total += product.price * quantity;
    }

    return total;
  }

  double get deliveryCharge {
    if (cartProducts.isEmpty) {
      return 0;
    }

    return 5;
  }

  double get discount {
    if (subtotal >= 80) {
      return 10;
    }

    return 0;
  }

  double get total {
    return subtotal + deliveryCharge - discount;
  }

  int get cartItemCount {
    int count = 0;

    for (final product in cartProducts) {
      count += cartQuantity[product.id] ?? 1;
    }

    return count;
  }

  void clearCart() {
    cartProducts.clear();
    cartQuantity.clear();

    notifyListeners();
  }



  List<OrderModel> orders = [];

  bool isLoadingOrders = false;
  String orderError = "";

  // Place Order
  Future<bool> placeOrder({
    required String userId,
    String paymentMethod = "Cash on Delivery",
  }) async {
    if (cartProducts.isEmpty) {
      orderError = "Your cart is empty.";
      notifyListeners();
      return false;
    }

    try {
      isLoadingOrders = true;
      orderError = "";
      notifyListeners();

      final orderRef = db.collection("orders").doc();

      final order = OrderModel(
        id: orderRef.id,
        userId: userId,
        date: DateTime.now(),
        products: List<ProductModel>.from(cartProducts),
        quantities: Map<String, int>.from(cartQuantity),
        subtotal: subtotal,
        deliveryFee: deliveryCharge,
        discount: discount,
        total: total,
        paymentMethod: paymentMethod,
        status: "Pending",
      );

      await orderRef.set(order.toMap());

      // Local list update
      orders.insert(0, order);

      // Clear cart after successful order
      cartProducts.clear();
      cartQuantity.clear();

      notifyListeners();

      return true;
    } catch (e) {
      orderError = e.toString();

      debugPrint("Place Order Error: $e");

      notifyListeners();

      return false;
    } finally {
      isLoadingOrders = false;
      notifyListeners();
    }
  }

  // Get user's orders
  Future<void> getOrders(String userId) async {
    try {
      isLoadingOrders = true;
      orderError = "";
      notifyListeners();

      final snapshot = await db
          .collection("orders")
          .where(
        "userId",
        isEqualTo: userId,
      )
          .get();

      orders = snapshot.docs.map((doc) {
        return OrderModel.fromMap(doc.data());
      }).toList();

      orders.sort(
            (a, b) => b.date.compareTo(a.date),
      );
    } catch (e) {
      orderError = e.toString();

      debugPrint("Get Orders Error: $e");
    } finally {
      isLoadingOrders = false;
      notifyListeners();
    }
  }



  void clearOrders() {
    orders.clear();
    notifyListeners();
  }
}



List<Widget> screens = [
  const HomeScreen(),
  const CategoriesScreen(),
  const WishlistScreen(),
  const CartScreen(),
  const ProfileScreen(),
];