import 'package:cloud_firestore/cloud_firestore.dart';

class SosService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ==========================================
  // CREATE SOS ALERT
  // ==========================================
  Future<String> createSOS({
    required double latitude,
    required double longitude,
    double accuracy = 0.0,
    double speed = 0.0,
    double heading = 0.0,
  }) async {
    try {
      print("========== CREATE SOS ==========");
      print("Latitude  : $latitude");
      print("Longitude : $longitude");
      print("Accuracy  : $accuracy");
      print("Speed     : $speed");
      print("Heading   : $heading");

      final doc = await _firestore.collection("sos_alerts").add({
        "latitude": latitude,
        "longitude": longitude,
        "accuracy": accuracy,
        "speed": speed,
        "heading": heading,
        "active": true,
        "createdAt": FieldValue.serverTimestamp(),
        "lastUpdated": FieldValue.serverTimestamp(),
      });

      // Save the first location in route history
      await doc.collection("route").add({
        "latitude": latitude,
        "longitude": longitude,
        "accuracy": accuracy,
        "speed": speed,
        "heading": heading,
        "time": FieldValue.serverTimestamp(),
      });

      print("✅ Firestore document created");
      print("Document ID : ${doc.id}");
      print("================================");

      return doc.id;
    } catch (e) {
      print("❌ CREATE SOS ERROR");
      print(e);
      rethrow;
    }
  }

  // ==========================================
  // UPDATE LIVE LOCATION
  // ==========================================
  Future<void> updateLocation({
    required String alertId,
    required double latitude,
    required double longitude,
    required double accuracy,
    required double speed,
    required double heading,
  }) async {
    try {
      // Update latest location
      await _firestore.collection("sos_alerts").doc(alertId).update({
        "latitude": latitude,
        "longitude": longitude,
        "accuracy": accuracy,
        "speed": speed,
        "heading": heading,
        "lastUpdated": FieldValue.serverTimestamp(),
      });

      // Save route history
      await _firestore
          .collection("sos_alerts")
          .doc(alertId)
          .collection("route")
          .add({
        "latitude": latitude,
        "longitude": longitude,
        "accuracy": accuracy,
        "speed": speed,
        "heading": heading,
        "time": FieldValue.serverTimestamp(),
      });

      print("📍 Live location updated");
      print("🛣 Route point saved");
    } catch (e) {
      print("❌ UPDATE LOCATION ERROR");
      print(e);
    }
  }

  // ==========================================
  // STOP SOS
  // ==========================================
  Future<void> stopSOS(String alertId) async {
    try {
      await _firestore.collection("sos_alerts").doc(alertId).update({
        "active": false,
        "endedAt": FieldValue.serverTimestamp(),
        "lastUpdated": FieldValue.serverTimestamp(),
      });

      print("✅ SOS stopped");
    } catch (e) {
      print("❌ STOP SOS ERROR");
      print(e);
    }
  }

  // ==========================================
  // GET LIVE SOS
  // ==========================================
  Stream<DocumentSnapshot<Map<String, dynamic>>> getSOS(
    String alertId,
  ) {
    return _firestore
        .collection("sos_alerts")
        .doc(alertId)
        .snapshots();
  }

  // ==========================================
  // GET ROUTE HISTORY
  // ==========================================
  Stream<QuerySnapshot<Map<String, dynamic>>> getRoute(
    String alertId,
  ) {
    return _firestore
        .collection("sos_alerts")
        .doc(alertId)
        .collection("route")
        .orderBy("time")
        .snapshots();
  }
}