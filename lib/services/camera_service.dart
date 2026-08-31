import 'dart:io';

import 'package:camera/camera.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class CameraService {
  CameraController? _controller;

  List<CameraDescription>? _cameras;

  bool _initialized = false;

  /// Initialize rear camera
  Future<void> initialize() async {
    if (_initialized) return;

    _cameras = await availableCameras();

    if (_cameras == null || _cameras!.isEmpty) {
      throw Exception("No cameras found");
    }

    // Find rear camera
    CameraDescription rearCamera = _cameras!.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.back,
      orElse: () => _cameras!.first,
    );

    _controller = CameraController(
      rearCamera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _controller!.initialize();

    _initialized = true;

    print("Rear camera initialized");
  }

  /// Capture photo
  Future<String> capturePhoto() async {
    if (!_initialized || _controller == null) {
      throw Exception("Camera not initialized");
    }

    final XFile image = await _controller!.takePicture();

    final Directory directory =
        await getApplicationDocumentsDirectory();

    final String evidenceFolder =
        path.join(directory.path, "evidence");

    await Directory(evidenceFolder).create(
      recursive: true,
    );

    final String fileName =
        "IMG_${DateTime.now().millisecondsSinceEpoch}.jpg";

    final String savedPath =
        path.join(evidenceFolder, fileName);

    await File(image.path).copy(savedPath);

    print("Photo captured");
    print(savedPath);

    return savedPath;
  }

  /// Check initialization
  bool get isInitialized => _initialized;

  /// Camera preview controller
  CameraController? get controller => _controller;

  /// Dispose camera
  Future<void> dispose() async {
    await _controller?.dispose();

    _controller = null;

    _initialized = false;

    print("Camera disposed");
  }
}