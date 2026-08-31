import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../home/home_screen.dart';



class PermissionScreen extends StatefulWidget {

  const PermissionScreen({super.key});


  @override
  State<PermissionScreen> createState() =>
      _PermissionScreenState();

}




class _PermissionScreenState
    extends State<PermissionScreen> {


  bool loading = false;





  Future<void> requestPermissions() async {


    setState(() {

      loading = true;

    });





    Map<Permission, PermissionStatus> statuses =

    await [

      // GPS
      Permission.location,


      // Emergency Evidence
      Permission.camera,


      Permission.microphone,


      // Alerts
      Permission.notification,


      // Smart Jewellery
      Permission.bluetoothScan,

      Permission.bluetoothConnect,


      // SOS SMS
      Permission.sms,


      // Fake Call
      Permission.phone,


    ].request();







    bool locationGranted =

        statuses[Permission.location] ==
            PermissionStatus.granted;




    bool smsGranted =

        statuses[Permission.sms] ==
            PermissionStatus.granted;






    if(!mounted) return;





    setState(() {

      loading = false;

    });






    if(!locationGranted || !smsGranted){



      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(

          content: Text(

            "Location and SMS permissions are required for SOS."

          ),

        ),

      );


      return;

    }








    Navigator.pushReplacement(

      context,

      MaterialPageRoute(

        builder: (_) =>
            const HomeScreen(),

      ),

    );



  }








  Widget permissionTile(

      IconData icon,

      String title,

      ) {


    return Card(


      margin:

      const EdgeInsets.symmetric(

        vertical:8,

      ),



      child:

      ListTile(



        leading:

        Icon(

          icon,

          color:

          Colors.red,

        ),



        title:

        Text(title),



        trailing:

        const Icon(

          Icons.check_circle_outline,

          color:

          Colors.green,

        ),


      ),


    );


  }









  @override
  Widget build(BuildContext context) {



    return Scaffold(



      appBar:

      AppBar(

        title:

        const Text(

          "Permissions",

        ),


        centerTitle:

        true,


      ),






      body:

      Padding(

        padding:

        const EdgeInsets.all(20),



        child:

        Column(



          children:[



            const SizedBox(

              height:20,

            ),





            const Icon(

              Icons.security,

              size:90,

              color:Colors.red,

            ),





            const SizedBox(

              height:20,

            ),






            const Text(

              "Allow Required Permissions",

              style:

              TextStyle(

                fontSize:24,

                fontWeight:

                FontWeight.bold,

              ),

            ),





            const SizedBox(

              height:10,

            ),





            const Text(

              "SafeBee needs these permissions to provide emergency safety features.",

              textAlign:

              TextAlign.center,

            ),






            const SizedBox(

              height:30,

            ),






            permissionTile(

              Icons.location_on,

              "GPS Location",

            ),




            permissionTile(

              Icons.sms,

              "Emergency SMS",

            ),




            permissionTile(

              Icons.camera_alt,

              "Camera Evidence",

            ),




            permissionTile(

              Icons.mic,

              "Audio Recording",

            ),




            permissionTile(

              Icons.notifications,

              "Emergency Notifications",

            ),




            permissionTile(

              Icons.bluetooth,

              "Smart Jewellery Bluetooth",

            ),




            const Spacer(),





            SizedBox(

              width:

              double.infinity,



              height:

              55,




              child:

              ElevatedButton(



                onPressed:

                loading

                ? null

                : requestPermissions,





                child:

                loading

                ?

                const CircularProgressIndicator(

                  color:

                  Colors.white,

                )



                :

                const Text(

                  "Allow Permissions",

                  style:

                  TextStyle(

                    fontSize:18,

                  ),

                ),



              ),


            ),





            const SizedBox(

              height:20,

            ),



          ],


        ),


      ),


    );


  }


}