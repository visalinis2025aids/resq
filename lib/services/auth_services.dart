import 'package:firebase_auth/firebase_auth.dart';


class AuthService {


  final FirebaseAuth _auth = FirebaseAuth.instance;



  // ==============================
  // CURRENT USER
  // ==============================

  User? get currentUser {

    return _auth.currentUser;

  }




  // ==============================
  // EMAIL LOGIN
  // ==============================

  Future<UserCredential?> loginWithEmail(

      String email,

      String password,

      ) async {


    try {


      UserCredential userCredential =

      await _auth.signInWithEmailAndPassword(

        email: email,

        password: password,

      );


      return userCredential;



    }

    on FirebaseAuthException catch(e){


      print(
          "Email Login Error: ${e.message}"
      );


      return null;


    }


  }







  // ==============================
  // EMAIL REGISTER
  // ==============================

  Future<UserCredential?> registerWithEmail(

      String email,

      String password,

      ) async {



    try {


      UserCredential userCredential =

      await _auth.createUserWithEmailAndPassword(

        email: email,

        password: password,

      );


      return userCredential;



    }

    on FirebaseAuthException catch(e){


      print(
          "Register Error: ${e.message}"
      );


      return null;


    }


  }








  // ==============================
  // SEND PHONE OTP
  // ==============================


  Future<void> sendOTP({


    required String phoneNumber,


    required Function(String verificationId)

    codeSent,



    required Function(FirebaseAuthException e)

    verificationFailed,



    required Function(PhoneAuthCredential credential)

    verificationCompleted,


  }) async {



    print("==============================");

    print("Starting Phone Authentication");

    print("Phone Number : $phoneNumber");

    print("==============================");





    await _auth.verifyPhoneNumber(



      phoneNumber: phoneNumber,





      verificationCompleted:

          (PhoneAuthCredential credential) async {



        print(
            "AUTO VERIFICATION SUCCESS"
        );



        verificationCompleted(

            credential

        );


      },






      verificationFailed:

          (FirebaseAuthException e){



        print(
            "OTP FAILED"
        );


        print(
            "Error Code : ${e.code}"
        );


        print(
            "Message : ${e.message}"
        );



        verificationFailed(

            e

        );


      },







      codeSent:

          (String verificationId, int? resendToken){



        print(
            "OTP SENT"
        );


        print(
            "Verification ID : $verificationId"
        );



        codeSent(

            verificationId

        );


      },







      codeAutoRetrievalTimeout:

          (String verificationId){



        print(
            "AUTO RETRIEVAL TIMEOUT"
        );


        print(
            verificationId
        );



      },


    );


  }









  // ==============================
  // VERIFY OTP
  // ==============================


  Future<UserCredential?> verifyOTP({



    required String verificationId,



    required String smsCode,



  }) async {



    try {



      PhoneAuthCredential credential =

      PhoneAuthProvider.credential(


        verificationId: verificationId,


        smsCode: smsCode,


      );





      UserCredential userCredential =


      await _auth.signInWithCredential(

          credential

      );






      print(
          "OTP VERIFIED SUCCESSFULLY"
      );



      return userCredential;




    }

    on FirebaseAuthException catch(e){



      print(
          "OTP VERIFY ERROR"
      );


      print(
          e.message
      );



      return null;



    }


  }









  // ==============================
  // LOGOUT
  // ==============================


  Future<void> logout() async {


    await _auth.signOut();


  }



}