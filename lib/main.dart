import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_easy/AdminApp/provider/admin_auth_view_model.dart';
import 'package:shop_easy/UserApp/UI/Screens/splashScreen/splash_screen.dart';
import 'package:shop_easy/UserApp/provider/auth_view_model.dart';
import 'package:shop_easy/UserApp/provider/product_view_model.dart';
import 'package:shop_easy/firebase_options.dart';

final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
final navigatorKey = GlobalKey<NavigatorState>();

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());

}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => ProductViewModel(),
          ),
          ChangeNotifierProvider(create: (context) => AuthViewModel(),),


        ],

      child: MaterialApp(
        navigatorKey: navigatorKey,
        scaffoldMessengerKey: scaffoldMessengerKey,
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}


