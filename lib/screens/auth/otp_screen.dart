import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../services/auth_services.dart';



class OTPScreen extends StatefulWidget {


  final String verificationId;

  final String phoneNumber;



  const OTPScreen({

    super.key,

    required this.verificationId,

    required this.phoneNumber,

  });



  @override
  State<OTPScreen> createState() => _OTPScreenState();

}






class _OTPScreenState extends State<OTPScreen> {



  final TextEditingController otpController =
      TextEditingController();



  final AuthService authService =
      AuthService();



  bool loading = false;






  Future<void> verifyOTP() async {



    final otp =
        otpController.text.trim();




    if(otp.length != 6){


      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(

          content:

          Text(
            "Enter 6 digit OTP",
          ),

        ),

      );


      return;

    }






    setState(() {

      loading = true;

    });






    try {



      UserCredential? user =

      await authService.verifyOTP(

        verificationId:

        widget.verificationId,


        smsCode:

        otp,

      );







      if(user != null){



        if(!mounted) return;




        // OTP SUCCESS
        // GO TO HOME SCREEN


        Navigator.pushNamedAndRemoveUntil(

          context,


          "/home",


          (route)=>false,

        );



      }



      else {



        if(!mounted) return;



        setState(() {

          loading=false;

        });



        ScaffoldMessenger.of(context).showSnackBar(

          const SnackBar(

            content:

            Text(
              "Invalid OTP",
            ),

          ),

        );


      }




    }



    on FirebaseAuthException catch(e){



      if(!mounted) return;



      setState(() {

        loading=false;

      });




      ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(

          content:

          Text(

            e.message ??

                "OTP verification failed",

          ),

        ),

      );



    }



    catch(e){



      if(!mounted) return;



      setState(() {

        loading=false;

      });



      ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(

          content:

          Text(
            e.toString(),
          ),

        ),

      );


    }



  }







  @override
  void dispose(){


    otpController.dispose();


    super.dispose();


  }









  @override
  Widget build(BuildContext context){



    return Scaffold(



      appBar:

      AppBar(

        title:

        const Text(

          "Verify OTP",

        ),

      ),






      body:

      Padding(

        padding:

        const EdgeInsets.all(20),



        child:

        Column(


          mainAxisAlignment:

          MainAxisAlignment.center,



          children:[




            Text(

              "OTP sent to ${widget.phoneNumber}",


              style:

              const TextStyle(

                fontSize:16,

              ),

            ),






            const SizedBox(height:20),






            TextField(


              controller:

              otpController,



              keyboardType:

              TextInputType.number,



              maxLength:6,



              decoration:

              const InputDecoration(

                labelText:

                "Enter OTP",

                border:

                OutlineInputBorder(),

              ),

            ),






            const SizedBox(height:20),






            SizedBox(

              width:

              double.infinity,


              height:50,



              child:

              ElevatedButton(



                onPressed:

                loading ? null : verifyOTP,



                child:


                loading

                    ?

                const CircularProgressIndicator(

                  color:Colors.white,

                )


                    :


                const Text(

                  "Verify OTP",

                  style:

                  TextStyle(

                    fontSize:18,

                  ),

                ),



              ),

            ),




          ],


        ),


      ),



    );


  }



}