import 'package:permission_handler/permission_handler.dart';


class PermissionService {


  Future<bool> requestLocation() async {

    var status =
        await Permission.location.request();

    return status.isGranted;
  }



  Future<bool> requestBluetooth() async {

    var status =
        await Permission.bluetooth.request();

    return status.isGranted;

  }



  Future<bool> requestNotification() async {

    var status =
        await Permission.notification.request();

    return status.isGranted;

  }



  Future<bool> requestSMS() async {

    var status =
        await Permission.sms.request();

    return status.isGranted;

  }



  Future<bool> requestAllPermissions() async {


    bool bluetooth =
        await requestBluetooth();


    bool location =
        await requestLocation();


    bool notification =
        await requestNotification();


    bool sms =
        await requestSMS();



    return bluetooth &&
        location &&
        notification &&
        sms;

  }


}