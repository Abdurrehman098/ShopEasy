import 'package:flutter/material.dart';
import 'package:shop_easy/AdminApp/UI/Screens/Dashboard/dashboard_screen.dart';
import 'package:shop_easy/AdminApp/UI/Screens/category/category_screen.dart';
import 'package:shop_easy/AdminApp/UI/Screens/order/order_screen.dart';
import 'package:shop_easy/AdminApp/UI/Screens/product/product_screen.dart';


class BottomNavigationProvider extends ChangeNotifier {
  int currentIndex = 0;

  void onClick(int index) {
    currentIndex = index;
    notifyListeners();
  }

}

List<Widget>screens = [
  AdminDashboardScreen(),
  AdminProductsScreen(),
  AdminCategoriesScreen(),
  AdminOrdersScreen(),

];