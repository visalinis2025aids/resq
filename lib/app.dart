import 'package:flutter/material.dart';

import '../screens/splash/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/home/home_screen.dart';



class AppRoutes {


  static const String splash = "/";

  static const String login = "/login";

  static const String home = "/home";



  // Add this because main.dart and app.dart use AppRoutes.routes

  static final Map<String, WidgetBuilder> routes = {


    splash: (context) =>
        const SplashScreen(),



    login: (context) =>
        const LoginScreen(),



    home: (context) =>
        const HomeScreen(),


  };



}