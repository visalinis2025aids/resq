import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {

    return Column(

      children: const [

        CircleAvatar(

          radius: 45,

          backgroundColor: Colors.red,

          child: Icon(

            Icons.health_and_safety,

            color: Colors.white,

            size: 50,

          ),

        ),

        SizedBox(height: 15),

        Text(

          "SafeBee",

          style: TextStyle(

            fontSize: 32,

            fontWeight: FontWeight.bold,

          ),

        ),

        SizedBox(height: 8),

        Text(

          "Smart Jewellery Safety",

          style: TextStyle(

            fontSize: 16,

          ),

        )

      ],

    );

  }

}