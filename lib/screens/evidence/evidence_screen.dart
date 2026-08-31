import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../services/evidence_service.dart';
import 'image_view_screen.dart';

class EvidenceScreen extends StatefulWidget {
  final String alertId;

  const EvidenceScreen({
    super.key,
    required this.alertId,
  });

  @override
  State<EvidenceScreen> createState() => _EvidenceScreenState();
}

class _EvidenceScreenState extends State<EvidenceScreen> {
  final EvidenceService _evidenceService = EvidenceService();

  bool _isCapturing = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      await _evidenceService.initialize();
    } catch (e) {
      debugPrint("Camera Init Error: $e");
    }
  }

  Future<void> _captureEvidence() async {
    if (_isCapturing) return;

    setState(() {
      _isCapturing = true;
    });

    try {
      await _evidenceService.captureEvidence(
        alertId: widget.alertId,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Evidence captured successfully"),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Capture failed: $e"),
          ),
        );
      }
    }

    if (mounted) {
      setState(() {
        _isCapturing = false;
      });
    }
  }

  @override
  void dispose() {
    _evidenceService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Evidence"),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed:
                    _isCapturing ? null : _captureEvidence,
                icon: const Icon(Icons.camera_alt),
                label: Text(
                  _isCapturing
                      ? "Capturing..."
                      : "Capture Evidence",
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("sos_alerts")
                  .doc(widget.alertId)
                  .collection("evidence")
                  .orderBy(
                    "capturedAt",
                    descending: true,
                  )
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData ||
                    snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      "No Evidence Captured",
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                }

                final docs = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data =
                        docs[index].data()
                            as Map<String, dynamic>;

                    final Timestamp? ts =
                        data["capturedAt"];

                    final String time =
                        ts == null
                            ? ""
                            : DateFormat(
                                "dd MMM yyyy  hh:mm a",
                              ).format(
                                ts.toDate(),
                              );

              return Card(
  margin: const EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 6,
  ),
  elevation: 3,
  child: InkWell(
    borderRadius: BorderRadius.circular(8),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ImageViewScreen(
            imagePath: data["imagePath"],
          ),
        ),
      );
    },
    child: ListTile(
      contentPadding: const EdgeInsets.all(8),

      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(
          File(data["imagePath"]),
          width: 70,
          height: 70,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 70,
              height: 70,
              color: Colors.grey.shade300,
              child: const Icon(
                Icons.broken_image,
                color: Colors.red,
              ),
            );
          },
        ),
      ),

      title: Text(
        time,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),

      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Latitude : ${data["latitude"]}"),
          Text("Longitude : ${data["longitude"]}"),
        ],
      ),

      trailing: const Icon(
        Icons.open_in_full,
        color: Colors.red,
      ),
    ),
  ),
);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}      