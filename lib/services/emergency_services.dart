import 'package:geolocator/geolocator.dart';

import 'contact_service.dart';
import 'location_service.dart';

class EmergencyService {
  final LocationService _locationService = LocationService();
  final ContactService _contactService = ContactService();

  // ==========================================
  // GET CURRENT LOCATION
  // ==========================================

  Future<Position?> getCurrentLocation() async {
    return await _locationService.getCurrentLocation();
  }

  // ==========================================
  // GET EMERGENCY CONTACT NUMBERS
  // ==========================================

  Future<List<String>> getEmergencyContactNumbers() async {
    return await _contactService.getEmergencyNumbers();
  }
}