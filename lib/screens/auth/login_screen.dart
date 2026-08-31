import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'register_screen.dart';


class LoginScreen extends StatefulWidget {

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();

}



class _LoginScreenState extends State<LoginScreen> {


  final FirebaseAuth _auth = FirebaseAuth.instance;


  final TextEditingController emailController =
      TextEditingController();


  final TextEditingController passwordController =
      TextEditingController();



  bool loading = false;

  bool obscurePassword = true;




  // EMAIL LOGIN

  Future<void> login() async {


    final email = emailController.text.trim();

    final password = passwordController.text.trim();



    if(email.isEmpty || password.isEmpty){


      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(
          content: Text(
            "Please enter email and password",
          ),
        ),

      );

      return;

    }



    setState(() {

      loading = true;

    });



    try {


      UserCredential credential =

      await _auth.signInWithEmailAndPassword(

        email: email,

        password: password,

      );



      if(credential.user != null){


        if(!mounted) return;


        Navigator.pushReplacementNamed(

          context,

          "/home",

        );


      }



    }


    on FirebaseAuthException catch(e){


      String message = "Login failed";


      switch(e.code){


        case "user-not-found":

          message =
          "No account found with this email.";

          break;



        case "wrong-password":

          message =
          "Wrong password.";

          break;



        case "invalid-email":

          message =
          "Invalid email address.";

          break;



        case "invalid-credential":

          message =
          "Invalid email or password.";

          break;



        case "user-disabled":

          message =
          "This account is disabled.";

          break;



        default:

          message =
              e.message ?? "Login failed";


      }




      if(!mounted) return;



      ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(

          content: Text(message),

        ),

      );


    }



    finally{


      if(mounted){

        setState(() {

          loading = false;

        });

      }

    }


  }






  // RESET PASSWORD

  Future<void> resetPassword() async {


    final email =
        emailController.text.trim();



    if(email.isEmpty){


      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(

          content:
          Text(
              "Enter your email first"
          ),

        ),

      );


      return;

    }



    try{


      await _auth.sendPasswordResetEmail(

        email: email,

      );



      if(!mounted) return;



      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(

          content:
          Text(
              "Password reset email sent"
          ),

        ),

      );


    }


    on FirebaseAuthException catch(e){



      if(!mounted) return;



      ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(

          content:

          Text(

            e.message ??

                "Unable to send reset email",

          ),

        ),

      );


    }


  }







  @override
  void dispose(){


    emailController.dispose();

    passwordController.dispose();


    super.dispose();

  }








  @override
  Widget build(BuildContext context){


    return Scaffold(


      appBar: AppBar(

        title:

        const Text(

          "SafeBee Login",

        ),

        centerTitle: true,

      ),




      body:


      SingleChildScrollView(


        padding:

        const EdgeInsets.all(20),



        child:


        Column(


          children:[



            const SizedBox(height:30),



            const Icon(

              Icons.health_and_safety,

              size:100,

              color:Colors.red,

            ),




            const SizedBox(height:30),




            TextField(


              controller: emailController,


              keyboardType:

              TextInputType.emailAddress,



              decoration:

              const InputDecoration(

                labelText:"Email",

                border:

                OutlineInputBorder(),

              ),


            ),




            const SizedBox(height:20),




            TextField(


              controller: passwordController,


              obscureText: obscurePassword,



              decoration:

              InputDecoration(


                labelText:"Password",


                border:

                const OutlineInputBorder(),



                suffixIcon:

                IconButton(


                  icon:

                  Icon(

                    obscurePassword

                        ? Icons.visibility

                        : Icons.visibility_off,

                  ),



                  onPressed:(){


                    setState(() {


                      obscurePassword =

                      !obscurePassword;


                    });


                  },


                ),

              ),


            ),






            Align(


              alignment:

              Alignment.centerRight,



              child:


              TextButton(


                onPressed:

                resetPassword,



                child:

                const Text(

                  "Forgot Password?",

                ),


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

                loading ? null : login,



                child:


                loading

                    ?


                const CircularProgressIndicator(

                  color:Colors.white,

                )


                    :


                const Text(

                  "Login",

                  style:

                  TextStyle(

                    fontSize:18,

                  ),

                ),


              ),


            ),






            const SizedBox(height:15),






            SizedBox(


              width:

              double.infinity,


              height:50,



              child:


              ElevatedButton.icon(


                icon:

                const Icon(

                  Icons.phone_android,

                ),



                label:

                const Text(

                  "Login with Phone OTP",

                ),




                onPressed:(){


                  Navigator.pushNamed(

                    context,

                    "/phoneLogin",

                  );


                },


              ),


            ),






            const SizedBox(height:20),






            Row(


              mainAxisAlignment:

              MainAxisAlignment.center,



              children:[



                const Text(

                  "Don't have an account?",

                ),




                TextButton(


                  onPressed:(){


                    Navigator.push(

                      context,


                      MaterialPageRoute(


                        builder:(context)=>


                        const RegisterScreen(),


                      ),


                    );


                  },



                  child:

                  const Text(

                    "Create Account",

                  ),


                ),


              ],


            ),


          ],


        ),


      ),


    );


  }


}