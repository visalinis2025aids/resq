import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../services/location_service.dart';
import '../../services/contact_service.dart';
import '../../services/sms_service.dart';
import '../../services/emergency_services.dart';
import '../../services/tracking_service.dart';

import '../location/live_location_screen.dart';
import 'sos_service.dart';



class SosScreen extends StatefulWidget {

  const SosScreen({
    super.key,
  });


  @override
  State<SosScreen> createState() =>
      _SosScreenState();

}





class _SosScreenState extends State<SosScreen> {


  int countdown = 5;

  Timer? timer;



  final LocationService locationService =
      LocationService();



  final ContactService contactService =
      ContactService();



  final SmsService smsService =
      SmsService();



  final EmergencyService emergencyService =
      EmergencyService();



  final SosService _sosService =
      SosService();



  final TrackingService _trackingService =
      TrackingService();



  String? _alertId;





  @override
  void initState() {

    super.initState();

    startCountdown();

  }





  // ===============================
  // COUNTDOWN
  // ===============================

  void startCountdown() {


    timer = Timer.periodic(

      const Duration(seconds: 1),

      (timer) {


        if (countdown == 1) {


          timer.cancel();


          activateSOS();


        } 
        
        else {


          if (mounted) {


            setState(() {


              countdown--;


            });


          }


        }


      },

    );

  }





  // ===============================
  // ACTIVATE SOS
  // ===============================


  Future<void> activateSOS() async {


    print(
      "========== SAFE BEE SOS START =========="
    );


    try {


      // 1. Get current location


      print(
        "Getting current location..."
      );



      final Position? position =
          await locationService
              .getCurrentLocation();



      if (position == null) {


        throw Exception(
          "Location unavailable"
        );


      }



      print(
        "Latitude : ${position.latitude}"
      );


      print(
        "Longitude : ${position.longitude}"
      );





      // 2. Create Firestore SOS document


      _alertId =
          await _sosService.createSOS(

        latitude:
            position.latitude,

        longitude:
            position.longitude,

        accuracy:
            position.accuracy,

        speed:
            position.speed,

        heading:
            position.heading,

      );



      print(
        "SOS Alert ID : $_alertId"
      );





      // 3. Start live tracking


      await _trackingService.startTracking(

        alertId:
            _alertId!,

      );



      print(
        "Tracking started"
      );





      // 4. Get emergency contacts


      final contacts =
          await contactService.getContacts();



      if (contacts.isEmpty) {


        throw Exception(
          "No emergency contacts found"
        );


      }





      final numbers =
          contacts

          .where(
            (c) =>
            c.phone.trim().isNotEmpty,
          )

          .map(
            (c) =>
            c.phone.trim(),
          )

          .toList();





      print(
        "Emergency numbers : $numbers"
      );





      // 5. Send SMS


      await smsService.sendSOSMessage(
  phoneNumbers: numbers,
   latitude: position.latitude,
  longitude: position.longitude,
  alertId: _alertId!,
);



      print(
        "SMS sent"
      );





      // 6. Open live location screen


      if (!mounted) return;



      Navigator.pushReplacement(

        context,

        MaterialPageRoute(

          builder: (_) =>
              LiveLocationScreen(

            alertId:
                _alertId!,

          ),

        ),

      );




    }

    catch(e, stack) {


      print(
        "SOS ERROR : $e"
      );


      print(stack);



      await _trackingService.stopTracking();



      if (_alertId != null) {

        await _sosService.stopSOS(
          _alertId!,
        );

      }



      if (!mounted) return;



      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(

          content:
          Text(
            "SOS Failed : $e"
          ),

        ),

      );


    }


    print(
      "========== SAFE BEE SOS END =========="
    );


  }





  // ===============================
  // CANCEL SOS
  // ===============================


  Future<void> cancelSOS() async {


    timer?.cancel();


    await _trackingService.stopTracking();



    if (_alertId != null) {


      await _sosService.stopSOS(
        _alertId!,
      );


    }



    if (!mounted) return;



    Navigator.pop(context);


  }







  // ===============================
  // I'M SAFE
  // ===============================


  Future<void> markSafe() async {


    timer?.cancel();


    await _trackingService.stopTracking();



    if (_alertId != null) {


      await _sosService.stopSOS(
        _alertId!,
      );


    }



    if (!mounted) return;



    Navigator.pop(context);


  }







  @override
  void dispose() {


    timer?.cancel();


    super.dispose();


  }







  @override
  Widget build(BuildContext context) {


    return Scaffold(


      backgroundColor:
      Colors.red.shade50,



      appBar: AppBar(


        backgroundColor:
        Colors.red,


        foregroundColor:
        Colors.white,


        title:
        const Text(
          "Emergency SOS",
        ),


      ),





      body: Center(


        child: Padding(


          padding:
          const EdgeInsets.all(24),



          child: Column(


            mainAxisAlignment:
            MainAxisAlignment.center,



            children: [



              const Icon(

                Icons.warning_rounded,

                size: 100,

                color: Colors.red,

              ),





              const SizedBox(height:20),




              const Text(

                "SOS will activate in",

                style: TextStyle(

                  fontSize:25,

                  fontWeight:
                  FontWeight.bold,

                ),

              ),





              const SizedBox(height:20),




              CircleAvatar(

                radius:60,

                backgroundColor:
                Colors.red,


                child:

                Text(

                  "$countdown",

                  style:
                  const TextStyle(

                    fontSize:50,

                    color:Colors.white,

                    fontWeight:
                    FontWeight.bold,

                  ),

                ),

              ),





              const SizedBox(height:40),





              SizedBox(

                width:
                double.infinity,

                height:55,


                child:
                ElevatedButton(


                  onPressed:
                  cancelSOS,


                  style:
                  ElevatedButton.styleFrom(

                    backgroundColor:
                    Colors.grey.shade800,

                    foregroundColor:
                    Colors.white,

                  ),


                  child:
                  const Text(
                    "Cancel SOS",
                  ),


                ),

              ),





              const SizedBox(height:15),





              SizedBox(

                width:
                double.infinity,

                height:55,


                child:
                ElevatedButton(


                  onPressed:
                  markSafe,


                  style:
                  ElevatedButton.styleFrom(

                    backgroundColor:
                    Colors.green,

                    foregroundColor:
                    Colors.white,

                  ),


                  child:
                  const Text(
                    "I'm Safe",
                  ),


                ),

              ),



            ],


          ),


        ),


      ),


    );


  }


}