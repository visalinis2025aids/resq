import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class LiveTrackingService {
  StreamSubscription<Position>? _subscription;

  void startTracking(String emergencyId) {
    _subscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 5,
      ),
    ).listen((Position position) async {
      await FirebaseFirestore.instance
          .collection("emergencies")
          .doc(emergencyId)
          .update({
        "latitude": position.latitude,
        "longitude": position.longitude,
        "updatedAt": FieldValue.serverTimestamp(),
      });
    });
  }

  Future<void> stopTracking() async {
    await _subscription?.cancel();
    _subscription = null;
  }
}