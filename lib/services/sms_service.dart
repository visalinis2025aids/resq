import 'package:url_launcher/url_launcher.dart';

class SmsService {
  Future<void> sendSOSMessage({
    required List<String> phoneNumbers,
    required double latitude,
    required double longitude,
    required String alertId,
  }) async {
    // Join all emergency contact numbers
    final phones = phoneNumbers.join(',');

    // SafeBee Live Tracker URL
    final trackingLink =
        "https://resq-204f0.web.app/?alertId=$alertId";

    // SMS Message
    final message = '''
🚨 SAFEBEE EMERGENCY ALERT 🚨

I need immediate help.

📍 Live Tracking:
$trackingLink

📍 Current Location (Google Maps):
https://maps.google.com/?q=$latitude,$longitude

Please help immediately.

Sent from SafeBee Safety Application
''';

    final Uri smsUri = Uri(
      scheme: 'sms',
      path: phones,
      queryParameters: {
        'body': message,
      },
    );

    print("========== SMS ==========");
    print("Recipients : $phones");
    print("Tracking Link : $trackingLink");
    print("Latitude : $latitude");
    print("Longitude : $longitude");
    print("=========================");

    final bool opened = await launchUrl(
      smsUri,
      mode: LaunchMode.externalApplication,
    );

    if (!opened) {
      throw Exception("Could not open SMS application");
    }

    print("SMS application opened successfully.");
  }
}