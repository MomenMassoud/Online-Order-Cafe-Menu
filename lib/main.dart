import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:youssef_starbucks/config/app_routes.dart';
import 'package:youssef_starbucks/providers/authentication_provider.dart';
import 'package:youssef_starbucks/providers/cart_provider.dart';
import 'package:youssef_starbucks/providers/feedback_provider.dart';
import 'package:youssef_starbucks/providers/order_provider.dart';
import 'package:youssef_starbucks/screens/landing_screen.dart';
import 'package:youssef_starbucks/config/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => AuthenticationProvider(FirebaseAuth.instance)),
        ChangeNotifierProvider(
            create: (_) => FeedbackProvider(
                FirebaseAuth.instance, FirebaseFirestore.instance)),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(
            create: (_) => OrderProvider(
                FirebaseAuth.instance, FirebaseFirestore.instance)),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: AppRoutes.router,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.brown,
        ),
        //home: const LandingScreen(),
      ),
    );
  }
}
