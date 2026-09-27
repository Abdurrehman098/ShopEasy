import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_easy/AdminApp/UI/Screens/Auth/admin_login.dart';
import 'package:shop_easy/AdminApp/provider/admin_auth_view_model.dart';
import 'package:shop_easy/AdminApp/provider/admin_category_view_model.dart';
import 'package:shop_easy/AdminApp/provider/admin_dashboard_view_model.dart';
import 'package:shop_easy/AdminApp/provider/admin_order_view_model.dart';
import 'package:shop_easy/AdminApp/provider/admin_product_view_model.dart';
import 'package:shop_easy/AdminApp/provider/bottom_navigation_provider.dart';
import 'package:shop_easy/firebase_options.dart';

final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
final navigatorKey = GlobalKey<NavigatorState>();

void main()async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(AdminApp());
}
class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AdminAuthProvider(),),
        ChangeNotifierProvider(create: (context) => BottomNavigationProvider(),),
        ChangeNotifierProvider(create: (context) => AdminDashboardProvider(),),
        ChangeNotifierProvider(create: (context) => AdminProductProvider(),),
        ChangeNotifierProvider(create: (context) => AdminCategoryProvider(),),
        ChangeNotifierProvider(create: (context) => AdminOrderProvider(),),



      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AdminLoginScreen(),

      ),
    );
  }
}
