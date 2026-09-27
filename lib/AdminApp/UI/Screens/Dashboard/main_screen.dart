import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_easy/AdminApp/Core/constant/colors.dart';
import 'package:shop_easy/AdminApp/provider/bottom_navigation_provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavigationProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          body: screens[provider.currentIndex],
          bottomNavigationBar: Container(
            padding: EdgeInsets.only(top: 5),
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,

              children: [
                InkWell(
                  onTap: () {
                    provider.onClick(0);
                  },
                  child: Column(
                    children: [
                      Icon(
                        Icons.home,
                        color: provider.currentIndex == 0
                            ? primaryColor
                            : secondaryColor,
                      ),
                      SizedBox(height: 3),
                      Text(
                        "Dashboard",
                        style: TextStyle(
                          color: provider.currentIndex == 0
                              ? primaryColor
                              : secondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    provider.onClick(1);
                  },
                  child: Column(
                    children: [
                      Icon(
                        Icons.grid_view_outlined,
                        color: provider.currentIndex == 1
                            ? primaryColor
                            : secondaryColor,
                      ),
                      SizedBox(height: 3),
                      Text(
                        "Products",
                        style: TextStyle(
                          color: provider.currentIndex == 1
                              ? primaryColor
                              : secondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    provider.onClick(2);
                  },
                  child: Column(
                    children: [
                      Icon(
                        Icons.person_outline,
                        color: provider.currentIndex == 2
                            ? primaryColor
                            : secondaryColor,
                      ),
                      SizedBox(height: 3),
                      Text(
                        "Categories",
                        style: TextStyle(
                          color: provider.currentIndex == 2
                              ? primaryColor
                              : secondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    provider.onClick(3);
                  },
                  child: Column(
                    children: [
                      Icon(
                        Icons.shopping_bag_outlined,
                        color: provider.currentIndex == 3
                            ? primaryColor
                            : secondaryColor,
                      ),
                      SizedBox(height: 3),
                      Text(
                        "Orders",
                        style: TextStyle(
                          color: provider.currentIndex == 3
                              ? primaryColor
                              : secondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
