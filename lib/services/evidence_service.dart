import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

import 'camera_service.dart';
import 'location_service.dart';

class EvidenceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final CameraService _cameraService = CameraService();

  final LocationService _locationService = LocationService();

  /// Initialize camera
  Future<void> initialize() async {
    if (!_cameraService.isInitialized) {
      await _cameraService.initialize();
    }
  }

  /// Capture one geo-tagged photo
  Future<void> captureEvidence({
    required String alertId,
  }) async {
    try {
      //-----------------------------------------
      // Capture Photo
      //-----------------------------------------

      final String imagePath =
          await _cameraService.capturePhoto();

      //-----------------------------------------
      // Get Current GPS
      //-----------------------------------------

      final Position position =
          await _locationService.getCurrentLocation();

      //-----------------------------------------
      // Save Evidence Metadata to Firestore
      //-----------------------------------------

      await _firestore
          .collection("sos_alerts")
          .doc(alertId)
          .collection("evidence")
          .add({
        "imagePath": imagePath,
        "latitude": position.latitude,
        "longitude": position.longitude,
        "accuracy": position.accuracy,
        "speed": position.speed,
        "heading": position.heading,
        "capturedAt": FieldValue.serverTimestamp(),
      });

      //-----------------------------------------
      // Debug Logs
      //-----------------------------------------

      print("================================");
      print("✅ Evidence Captured Successfully");
      print("Image Path : $imagePath");
      print("Latitude   : ${position.latitude}");
      print("Longitude  : ${position.longitude}");
      print("Accuracy   : ${position.accuracy}");
      print("Speed      : ${position.speed}");
      print("Heading    : ${position.heading}");
      print("================================");
    } catch (e) {
      print("❌ Evidence Error");
      print(e);
    }
  }

  /// Dispose camera
  Future<void> dispose() async {
    await _cameraService.dispose();
  }
}