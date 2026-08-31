import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';
import 'themes/app_theme.dart';
import 'routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const SafeBeeApp());
}

class SafeBeeApp extends StatelessWidget {
  const SafeBeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: "SafeBee",

      theme: AppTheme.lightTheme,

      routes: AppRoutes.routes,

      initialRoute: user == null ? "/login" : "/home",
    );
  }
}