import 'package:flutter/material.dart';

import 'package:flutter_blue_plus/flutter_blue_plus.dart'
    hide BluetoothService;

import '../../services/bluetooth_service.dart';



class BluetoothScreen extends StatefulWidget {

  const BluetoothScreen({
    super.key,
  });


  @override
  State<BluetoothScreen> createState() =>
      _BluetoothScreenState();

}




class _BluetoothScreenState
    extends State<BluetoothScreen> {


  final BluetoothService bluetoothService =
      BluetoothService();


  final List<BluetoothDevice> devices = [];


  bool scanning = false;



  @override
  void initState() {

    super.initState();

    scanDevices();

  }





  Future<void> scanDevices() async {


    setState(() {

      scanning = true;

      devices.clear();

    });



    await bluetoothService.startScan(

      onFound: (BluetoothDevice device) {


        if (!devices.any(
          (d) => d.remoteId == device.remoteId,
        )) {


          if (mounted) {

            setState(() {

              devices.add(device);

            });

          }

        }

      },

    );



    await Future.delayed(
      const Duration(seconds: 10),
    );


    if (mounted) {

      setState(() {

        scanning = false;

      });

    }

  }






  Future<void> connect(
      BluetoothDevice device) async {


    try {


      await bluetoothService.connect(device);



      if (!mounted) return;



      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(

          content: Text(

            "${device.platformName.isEmpty ? "Device" : device.platformName} Connected",

          ),

        ),

      );



      Navigator.pop(context);



    } catch (e) {


      if (!mounted) return;



      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(

          content: Text(
            "Connection Failed: $e",
          ),

        ),

      );

    }

  }







  @override
  void dispose() {

    bluetoothService.stopScan();

    super.dispose();

  }







  @override
  Widget build(BuildContext context) {


    return Scaffold(

      appBar: AppBar(

        title: const Text(
          "Smart Jewellery",
        ),


        backgroundColor: Colors.red,

        foregroundColor: Colors.white,

      ),





      body: Column(

        children: [


          if (scanning)

            const LinearProgressIndicator(),





          Expanded(

            child: devices.isEmpty


                ? const Center(

                    child: Text(
                      "No Bluetooth devices found",
                    ),

                  )



                : ListView.builder(

                    itemCount: devices.length,


                    itemBuilder:
                        (context, index) {


                      final device =
                          devices[index];



                      return Card(

                        margin:
                            const EdgeInsets.symmetric(

                          horizontal: 12,

                          vertical: 6,

                        ),



                        child: ListTile(


                          leading:
                              const Icon(

                            Icons.bluetooth,

                            color: Colors.blue,

                          ),




                          title: Text(

                            device.platformName.isEmpty

                                ? "Unknown Device"

                                : device.platformName,

                          ),




                          subtitle: Text(

                            device.remoteId.str,

                          ),





                          trailing:
                              ElevatedButton(


                            onPressed: () =>
                                connect(device),



                            child:
                                const Text(
                              "Connect",
                            ),

                          ),

                        ),

                      );

                    },

                  ),

          ),

        ],

      ),






      floatingActionButton:
          FloatingActionButton(


        backgroundColor: Colors.red,


        onPressed: scanDevices,


        child:
            const Icon(
          Icons.refresh,
        ),

      ),


    );

  }

}