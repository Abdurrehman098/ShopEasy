import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_easy/UserApp/UI/Screens/AuthScreens/login_screen.dart';
import 'package:shop_easy/UserApp/UI/Screens/order_screen/order_screen.dart';
import 'package:shop_easy/UserApp/UI/Screens/profile/edit_profile_screen.dart';
import 'package:shop_easy/UserApp/UI/Screens/whishlist/wishlist_screen.dart';
import 'package:shop_easy/UserApp/core/constant/colors.dart';
import 'package:shop_easy/UserApp/core/constant/text_style.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    final String userName =
    user?.displayName?.trim().isNotEmpty == true
        ? user!.displayName!.trim()
        : "User";

    final String userEmail = user?.email ?? "No email";

    final String? userPhoto = user?.photoURL;

    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0,
        title: Text(
          "My Profile",
          style: style16.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            const SizedBox(height: 20),

            // Profile Image
            CircleAvatar(
              radius: 45,
              backgroundColor: primaryColor,

              child: CircleAvatar(
                radius: 42,
                backgroundColor: Colors.grey.shade200,

                backgroundImage:
                userPhoto != null && userPhoto.isNotEmpty
                    ? NetworkImage(userPhoto)
                    : null,

                child:
                userPhoto == null || userPhoto.isEmpty
                    ? Icon(
                  Icons.person,
                  size: 55,
                  color: secondaryColor,
                )
                    : null,
              ),
            ),

            const SizedBox(height: 10),

            // Name
            Text(
              userName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 3),

            // Email
            Text(
              userEmail,
              style: TextStyle(
                fontSize: 12,
                color: secondaryColor,
              ),
            ),

            const SizedBox(height: 25),

            // Profile Options
            Container(
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.shade300,
                ),
              ),

              child: Column(
                children: [
                  // My Orders
                  ListTile(
                    leading: const Icon(
                      Icons.inventory_2_outlined,
                      size: 20,
                    ),

                    title: const Text(
                      "My Orders",
                      style: TextStyle(fontSize: 13),
                    ),

                    trailing: const Icon(
                      Icons.chevron_right,
                      size: 18,
                    ),

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                          const OrderScreen(),
                        ),
                      );
                    },
                  ),

                  Divider(
                    height: 1,
                    color: Colors.grey.shade200,
                  ),

                  // Wishlist
                  ListTile(
                    leading: const Icon(
                      Icons.favorite_border,
                      size: 20,
                    ),

                    title: const Text(
                      "My Wishlist",
                      style: TextStyle(fontSize: 13),
                    ),

                    trailing: const Icon(
                      Icons.chevron_right,
                      size: 18,
                    ),

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                          const WishlistScreen(),
                        ),
                      );
                    },
                  ),

                  Divider(
                    height: 1,
                    color: Colors.grey.shade200,
                  ),

                  // Edit Profile
                  ListTile(
                    leading: const Icon(
                      Icons.person_outline,
                      size: 20,
                    ),

                    title: const Text(
                      "Edit Profile",
                      style: TextStyle(fontSize: 13),
                    ),

                    trailing: const Icon(
                      Icons.chevron_right,
                      size: 18,
                    ),

                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                          const EditProfileScreen(),
                        ),
                      );

                      // Refresh profile after returning
                      if (mounted) {
                        setState(() {});
                      }
                    },
                  ),

                  Divider(
                    height: 1,
                    color: Colors.grey.shade200,
                  ),

                  // Logout
                  ListTile(
                    leading: const Icon(
                      Icons.logout,
                      size: 20,
                      color: Colors.red,
                    ),

                    title: const Text(
                      "Logout",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.red,
                      ),
                    ),

                    trailing: const Icon(
                      Icons.chevron_right,
                      size: 18,
                      color: Colors.red,
                    ),

                    onTap: () async {
                      await FirebaseAuth.instance.signOut();

                      if (!context.mounted) return;

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                          const LoginScreen(),
                        ),
                            (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}