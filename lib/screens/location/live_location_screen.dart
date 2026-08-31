import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../services/location_service.dart';
import '../../services/tracking_service.dart';

import '../sos/sos_service.dart';
import '../evidence/evidence_screen.dart';

class LiveLocationScreen extends StatefulWidget {
  final String alertId;

  const LiveLocationScreen({
    super.key,
    required this.alertId,
  });

  @override
  State<LiveLocationScreen> createState() =>
      _LiveLocationScreenState();
}

class _LiveLocationScreenState
    extends State<LiveLocationScreen> {
  final LocationService _locationService =
      LocationService();

  final TrackingService _trackingService =
      TrackingService();

  final SosService _sosService =
      SosService();

  final MapController _mapController =
      MapController();

  StreamSubscription<Position>? _locationSubscription;

  LatLng _currentLocation =
      const LatLng(11.0168, 76.9558);

  bool _loading = true;

  bool _mapReady = false;

  double _latitude = 0;

  double _longitude = 0;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    try {
      final Position position =
          await _locationService.getCurrentLocation();

      _updateLocation(position);

      _locationSubscription =
          _locationService
              .getLiveLocation()
              .listen(
        (Position position) {
          _updateLocation(position);
        },
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  void _updateLocation(Position position) {
    final LatLng location = LatLng(
      position.latitude,
      position.longitude,
    );

    if (!mounted) return;

    setState(() {
      _currentLocation = location;

      _latitude = position.latitude;

      _longitude = position.longitude;

      _loading = false;
    });

    if (_mapReady) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        _mapController.move(
          location,
          _mapController.camera.zoom,
        );
      });
    }
  }

  Future<void> _endEmergency() async {
    try {
      await _trackingService.stopTracking();

      await _sosService.stopSOS(
        widget.alertId,
      );

      if (!mounted) return;

      Navigator.pop(context);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Live Location",
          ),
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }    return Scaffold(
      appBar: AppBar(
        title: const Text("Live Location"),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),

      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              mapController: _mapController,

              options: MapOptions(
                initialCenter: _currentLocation,
                initialZoom: 17,

                onMapReady: () {
                  _mapReady = true;

                  _mapController.move(
                    _currentLocation,
                    17,
                  );
                },
              ),

              children: [
                TileLayer(
                  urlTemplate:
                      "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                  userAgentPackageName:
                      "com.visalini.safebee",
                ),

                MarkerLayer(
                  markers: [
                    Marker(
                      point: _currentLocation,
                      width: 60,
                      height: 60,
                      child: const Icon(
                        Icons.my_location,
                        color: Colors.red,
                        size: 45,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  "Current GPS Location",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  "Latitude : ${_latitude.toStringAsFixed(6)}",
                ),

                Text(
                  "Longitude : ${_longitude.toStringAsFixed(6)}",
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _endEmergency,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      "I'm Safe",
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _endEmergency,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      "Cancel SOS",
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.camera_alt),
                    label: const Text(
                      "Capture Evidence",
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EvidenceScreen(
                            alertId: widget.alertId,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  } }