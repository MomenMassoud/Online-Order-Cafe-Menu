import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:youssef_starbucks/config/constants.dart';
import 'package:youssef_starbucks/models/order.dart';
import 'package:youssef_starbucks/models/product.dart';
import 'package:youssef_starbucks/screens/add_feedback_screen.dart';
import 'package:youssef_starbucks/screens/add_to_cart_screen.dart';
import 'package:youssef_starbucks/screens/checkout_screen.dart';
import 'package:youssef_starbucks/screens/feedback_list_screen.dart';
import 'package:youssef_starbucks/screens/landing_screen.dart';
import 'package:youssef_starbucks/screens/landing_two.dart';
import 'package:youssef_starbucks/screens/login_screen.dart';
import 'package:youssef_starbucks/screens/main_screen.dart';
import 'package:youssef_starbucks/screens/order_detail_screen.dart';
import 'package:youssef_starbucks/screens/sign_up_screen.dart';
import 'package:youssef_starbucks/screens/forget_pw_page.dart';
import 'package:youssef_starbucks/screens/CategoryPage.dart';
import '../screens/profile_screen.dart';
import '../screens/AdminPage.dart';
import '../screens/Employee.dart';



class AppRoutes {

  static final GoRouter _router = GoRouter(debugLogDiagnostics: true, routes: [
    GoRoute(
        path: '/', //
        name: landingScreenRoute,
        builder: (BuildContext context, GoRouterState state) =>
            const LandingScreen()),
    GoRoute(
        path: '/CategoryPage',
        name: CategoryPageRoute,
        builder: (BuildContext context, GoRouterState state) =>
         CategoryPage()),
    GoRoute(
        path: '/forget_pw_page',
        name: forgetpasswordRoute,
        builder: (BuildContext context, GoRouterState state) =>
        const ForgotPasswordScreen()),
    GoRoute(
        path: '/admin_page',
        name: adminpageRoute,
        builder: (BuildContext context, GoRouterState state) =>
         AdminPage()),
    GoRoute(
        path: '/emp_page',
        name: EmpPageRoute,
        builder: (BuildContext context, GoRouterState state) =>
         emp()),
    GoRoute(
        path: '/landing_two',
        name: landingScreenTwoRoute,
        builder: (BuildContext context, GoRouterState state) =>
            const LandingTwoScreen()),
    GoRoute(
        path: '/login_screen',
        name: loginScreenRoute,
        builder: (BuildContext context, GoRouterState state) =>
            const LoginScreen()),
    GoRoute(
        path: '/sign_up_screen',
        name: signUpScreenRoute,
        builder: (BuildContext context, GoRouterState state) =>
            const SignUpScreen()),
    GoRoute(
        path: '/main_screen',
        name: mainScreenRoute,
        builder: (BuildContext context, GoRouterState state) =>
            const MainScreen()),
    GoRoute(
        path: '/add_to_cart_screen',
        name: addToCartScreenRoute,
        builder: (BuildContext context, GoRouterState state) =>
            AddToCartScreen(product: state.extra as Product)
                    ),
    GoRoute(
        path: '/checkout_screen',
        name: checkoutScreenRoute,
        builder: (context, state) => CheckoutScreen(
          points: state.queryParams?.containsKey('points') == true
              ? state.queryParams!['points'] as double
              : 0,


        ),
    ),
    GoRoute(
        path: '/add_feedback_screen',
        name: addFeedbackScreenRoute,
        builder: (BuildContext context, GoRouterState state) =>
             FeedbackForm()),
    GoRoute(
        path: '/feedback_list_screen',
        name: feedbackListScreenRoute,
        builder: (BuildContext context, GoRouterState state) =>
             ListFeedback()),

    GoRoute(
        path: '/profile',
        name: profileRoute,
        builder: (BuildContext context, GoRouterState state) =>
            const ProfilePage()),
    GoRoute(
        path: '/order_detail',
        name: orderDetailRoute,
        builder: (BuildContext context, GoRouterState state) =>
            OrderDetailScreen(orderModel: state.extra as OrderModel)),
  ]);

  static GoRouter get router => _router;


}
