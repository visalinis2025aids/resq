import 'package:flutter/material.dart';

import '../screens/auth/login_screen.dart';
import '../screens/auth/phone_login_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/permissions/permission_screen.dart';
import '../screens/sos/sos_screen.dart';
import '../screens/bluetooth/bluetooth_screen.dart';



class AppRoutes {


  static const String login="/login";

  static const String phoneLogin="/phoneLogin";

  static const String permissions="/permissions";

  static const String home="/home";

  static const String sos="/sos";

  static const String bluetooth="/bluetooth";

  static const String evidence="/evidence";




  static final Map<String,WidgetBuilder> routes={



    login:
        (context)=>const LoginScreen(),



    phoneLogin:
        (context)=>const PhoneLoginScreen(),



    permissions:
        (context)=>const PermissionScreen(),



    home:
        (context)=>const HomeScreen(),



    sos:
        (context)=>const SosScreen(),



    bluetooth:
        (context)=>const BluetoothScreen(),



  };


}