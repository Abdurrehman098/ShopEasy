import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminDashboardProvider extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  bool isLoading = false;
  String error = "";

  int totalProducts = 0;
  int totalCategories = 0;
  int totalOrders = 0;
  int totalCustomers = 0;

  List<Map<String, dynamic>> recentOrders = [];

  Future<void> getDashboardData() async {
    try {
      isLoading = true;
      error = "";

      notifyListeners();

      final products = await firestore.collection("products").get();

      final categories = await firestore.collection("categories").get();

      final orders = await firestore
          .collection("orders")
          .orderBy("date", descending: true)
          .limit(4)
          .get();

      final customers = await firestore.collection("users").get();

      final allOrders = await firestore.collection("orders").get();

      totalProducts = products.size;
      totalCategories = categories.size;
      totalOrders = allOrders.size;
      totalCustomers = customers.size;

      recentOrders = orders.docs.map((doc) {
        final data = doc.data();

        return {
          "id": data["id"] ?? doc.id,
          "userId": data["userId"] ?? "",
          "total": _toDouble(data["total"]),
          "status": data["status"] ?? "Pending",
        };
      }).toList();
    } catch (e) {
      error = e.toString();

      debugPrint("Dashboard Error: $e");
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }

  double _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
      value?.toString() ?? "0",
    ) ??
        0.0;
  }
}