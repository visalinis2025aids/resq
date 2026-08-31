import 'dart:async';

import 'package:geolocator/geolocator.dart';

import '../screens/sos/sos_service.dart';

class TrackingService {
  final SosService _sosService = SosService();

  StreamSubscription<Position>? _positionSubscription;

  /// Start live tracking
  Future<void> startTracking({
    required String alertId,
  }) async {
    // Stop any previous tracking
    await stopTracking();

    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 1,
    );

    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen(
      (Position position) async {
        try {
          await _sosService.updateLocation(
            alertId: alertId,
            latitude: position.latitude,
            longitude: position.longitude,
            accuracy: position.accuracy,
            speed: position.speed,
            heading: position.heading,
          );

          print("========== LIVE TRACKING ==========");
          print("Latitude  : ${position.latitude}");
          print("Longitude : ${position.longitude}");
          print("Accuracy  : ${position.accuracy}");
          print("Speed     : ${position.speed}");
          print("Heading   : ${position.heading}");
          print("==================================");
        } catch (e) {
          print("Tracking Error: $e");
        }
      },
      onError: (error) {
        print("Location Stream Error: $error");
      },
    );
  }

  /// Stop live tracking
  Future<void> stopTracking() async {
    await _positionSubscription?.cancel();
    _positionSubscription = null;
  }

  /// Check whether tracking is active
  bool get isTracking => _positionSubscription != null;
}