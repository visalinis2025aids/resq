import 'dart:async';

import 'package:flutter/material.dart';

import '../auth/login_screen.dart';



class SplashScreen extends StatefulWidget {

  const SplashScreen({super.key});


  @override
  State<SplashScreen> createState() =>
      _SplashScreenState();

}



class _SplashScreenState extends State<SplashScreen> {



  @override
  void initState() {

    super.initState();


    Timer(

      const Duration(seconds: 3),

      () {

        if(mounted){


          Navigator.pushReplacement(

            context,

            MaterialPageRoute(

              builder: (context) =>
              const LoginScreen(),

            ),

          );


        }

      },

    );

  }




  @override
  Widget build(BuildContext context) {


    return Scaffold(

      backgroundColor:
      const Color(0xFFE53935),


      body:

      SafeArea(

        child:

        Center(

          child:

          Column(

            mainAxisAlignment:
            MainAxisAlignment.center,


            children: [



              Container(

                height:140,

                width:140,


                decoration:

                const BoxDecoration(

                  color:Colors.white,

                  shape:
                  BoxShape.circle,

                ),



                child:

                const Icon(

                  Icons.health_and_safety,

                  size:80,

                  color:
                  Color(0xFFE53935),

                ),


              ),



              const SizedBox(height:30),



              const Text(

                "SafeBee",

                style:

                TextStyle(

                  color:
                  Colors.white,

                  fontSize:40,

                  fontWeight:
                  FontWeight.bold,

                  letterSpacing:2,

                ),

              ),



              const SizedBox(height:10),



              const Text(

                "Your Safety. Your Strength.",

                style:

                TextStyle(

                  color:
                  Colors.white70,

                  fontSize:18,

                ),

              ),



              const SizedBox(height:50),



              const CircularProgressIndicator(

                color:
                Colors.white,

              )


            ],

          ),

        ),

      ),

    );

  }


}