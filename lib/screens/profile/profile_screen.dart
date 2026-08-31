import 'package:flutter/material.dart';


class ProfileScreen extends StatelessWidget {

  const ProfileScreen({super.key});


  @override
  Widget build(BuildContext context) {


    return Scaffold(

      appBar: AppBar(

        title:
        const Text(
          "Profile",
        ),

      ),



      body:

      const Center(

        child:

        Column(

          mainAxisAlignment:
          MainAxisAlignment.center,


          children: [


            Icon(

              Icons.account_circle,

              size:100,

              color:Colors.red,

            ),



            SizedBox(height:20),



            Text(

              "User Profile",

              style:

              TextStyle(

                fontSize:25,

                fontWeight:
                FontWeight.bold,

              ),

            ),



            SizedBox(height:10),



            Text(

              "Manage your SafeBee account",

            ),


          ],

        ),

      ),


    );


  }


}