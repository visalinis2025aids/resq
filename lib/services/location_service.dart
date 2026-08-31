import 'package:geolocator/geolocator.dart';

class LocationService {
  // ===========================
  // CHECK LOCATION PERMISSION
  // ===========================

  Future<bool> checkPermission() async {
    bool serviceEnabled =
        await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return false;
    }

    LocationPermission permission =
        await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  // ===========================
  // GET CURRENT LOCATION
  // ===========================

  Future<Position> getCurrentLocation() async {
    bool allowed = await checkPermission();

    if (!allowed) {
      throw Exception("Location permission denied");
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
    );
  }

  // ===========================
  // LIVE LOCATION STREAM
  // ===========================

  Stream<Position> getLiveLocation() async* {
    bool allowed = await checkPermission();

    if (!allowed) {
      throw Exception("Location permission denied");
    }

    const LocationSettings settings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 5,
    );

    yield* Geolocator.getPositionStream(
      locationSettings: settings,
    );
  }
}