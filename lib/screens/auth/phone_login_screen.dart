import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../services/auth_services.dart';
import 'otp_screen.dart';



class PhoneLoginScreen extends StatefulWidget {

  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() =>
      _PhoneLoginScreenState();

}




class _PhoneLoginScreenState extends State<PhoneLoginScreen> {


  final AuthService authService = AuthService();


  final TextEditingController phoneController =
      TextEditingController();



  bool loading = false;




  Future<void> sendOTP() async {


    String phone =
        phoneController.text.trim();



    if(phone.isEmpty){


      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(
          content: Text(
            "Enter your phone number",
          ),
        ),

      );

      return;

    }




    if(phone.length != 10){


      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(

          content:

          Text(
            "Enter valid 10 digit mobile number",
          ),

        ),

      );


      return;

    }




    setState(() {

      loading = true;

    });




    await authService.sendOTP(


      phoneNumber: "+91$phone",



      codeSent: (verificationId){



        if(!mounted) return;



        setState(() {

          loading=false;

        });



        Navigator.push(

          context,


          MaterialPageRoute(

            builder:(context)=>


            OTPScreen(

              verificationId: verificationId,

              phoneNumber: "+91$phone",

            ),

          ),

        );


      },





      verificationFailed:

      (FirebaseAuthException e){



        if(!mounted) return;



        setState(() {

          loading=false;

        });



        ScaffoldMessenger.of(context).showSnackBar(

          SnackBar(

            content:

            Text(

              e.message ??

                  "OTP Failed",

            ),

          ),

        );


      },





      verificationCompleted:

      (PhoneAuthCredential credential) async {



        try{


          await FirebaseAuth.instance
              .signInWithCredential(
            credential,
          );



          if(!mounted) return;



          Navigator.pushNamedAndRemoveUntil(

            context,

            "/home",

                (route)=>false,

          );



        }

        catch(e){

          print(
              "Auto Login Error: $e"
          );

        }


      },


    );


  }







  @override
  void dispose(){

    phoneController.dispose();

    super.dispose();

  }








  @override
  Widget build(BuildContext context){


    return Scaffold(


      appBar: AppBar(

        title:

        const Text(
          "Phone OTP Login",
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



            TextField(

              controller:

              phoneController,


              keyboardType:

              TextInputType.phone,


              maxLength:10,


              decoration:

              const InputDecoration(

                prefixText:"+91 ",

                labelText:
                "Mobile Number",

                border:
                OutlineInputBorder(),

              ),

            ),




            const SizedBox(height:30),




            SizedBox(

              width:
              double.infinity,


              height:55,



              child:

              ElevatedButton(


                onPressed:

                loading ? null : sendOTP,



                child:


                loading

                    ?

                const CircularProgressIndicator(

                  color:Colors.white,

                )


                    :


                const Text(

                  "Send OTP",

                  style:

                  TextStyle(

                    fontSize:18,

                  ),

                ),


              ),

            )

          ],


        ),


      ),


    );


  }


}