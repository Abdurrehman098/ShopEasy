import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_easy/UserApp/UI/Widgets/productCard/product_card.dart';
import 'package:shop_easy/UserApp/core/constant/colors.dart';
import 'package:shop_easy/UserApp/core/constant/text_style.dart';
import 'package:shop_easy/UserApp/provider/product_view_model.dart';
import 'package:shop_easy/main.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  void initState() {

    super.initState();
    Future.microtask(() {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final provider = Provider.of<ProductViewModel>(
          navigatorKey.currentContext!,
          listen: false,
        );

        provider.getWishlist(user.uid);

        if (provider.products.isEmpty) {
          provider.getProducts();
        }
      }
    });
  }
  @override
  Widget build(BuildContext context) {

    return Consumer<ProductViewModel>(
      builder: (context, provider, child) {
        final whishlistProducts = provider.wishlistProducts;
        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            toolbarHeight: 65,
            backgroundColor: whiteColor,
            title: Text("WishList", style: style28),
          ),
          body: provider.isLoadingProducts
              ? const Center(
            child: CircularProgressIndicator(),
          ):  whishlistProducts.isEmpty
              ? _emptyWishlist(context)
              : Padding(
                padding: const EdgeInsets.all(12),
                child: GridView.builder(
                    itemCount: whishlistProducts.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 0.72,
                    ),
                    itemBuilder: (context, index) {
                      final product = whishlistProducts[index];
                      return ProductCard(product: product);
                    },
                  ),
              ),
        );
      },
    );
  }
}

Widget _emptyWishlist(BuildContext context) {
  return SingleChildScrollView(
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
    
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
    
          children: [
            Container(
              height: 100,
              width: 100,
    
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
    
              child: const Icon(
                Icons.favorite_border,
                size: 55,
                color: Colors.grey,
              ),
            ),
    
            const SizedBox(height: 20),
    
            const Text(
              "Your Wishlist is Empty",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
    
            const SizedBox(height: 8),
    
            const Text(
              "Save your favorite products here\nand find them easily later.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.5),
            ),
    
            const SizedBox(height: 25),
    
            SizedBox(
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
    
                onPressed: () {
                  Navigator.pop(context);
                },
    
                child: const Text(
                  "Continue Shopping",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),

            ),
          ],
        ),
      ),
    ),
  );
}
