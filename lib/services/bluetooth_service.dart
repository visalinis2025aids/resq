import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothService {
  static final BluetoothService _instance =
      BluetoothService._internal();

  factory BluetoothService() => _instance;

  BluetoothService._internal();

  BluetoothDevice? connectedDevice;

  StreamSubscription<List<ScanResult>>? scanSubscription;

  StreamSubscription<BluetoothConnectionState>?
      connectionSubscription;

  bool get isConnected => connectedDevice != null;


  // Start Bluetooth Scan
  Future<void> startScan({
    required Function(BluetoothDevice device) onFound,
  }) async {

    await FlutterBluePlus.stopScan();

    await FlutterBluePlus.startScan(
      timeout: const Duration(seconds: 10),
    );


    scanSubscription =
        FlutterBluePlus.scanResults.listen(
      (results) {

        for (final result in results) {

          onFound(result.device);

        }

      },
    );
  }



  // Stop Bluetooth Scan
  Future<void> stopScan() async {

    await FlutterBluePlus.stopScan();

    await scanSubscription?.cancel();

    scanSubscription = null;
  }




  // Connect Jewellery Device
  Future<void> connect(
      BluetoothDevice device) async {

    await device.connect();

    connectedDevice = device;


    connectionSubscription =
        device.connectionState.listen(
      (state) {

        if (state ==
            BluetoothConnectionState.disconnected) {

          connectedDevice = null;

        }

      },
    );
  }




  // Disconnect Device
  Future<void> disconnect() async {

    if (connectedDevice != null) {

      await connectedDevice!.disconnect();

    }


    connectedDevice = null;


    await connectionSubscription?.cancel();

    connectionSubscription = null;
  }
}