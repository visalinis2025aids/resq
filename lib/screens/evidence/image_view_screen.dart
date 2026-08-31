import 'dart:io';

import 'package:flutter/material.dart';

class ImageViewScreen extends StatelessWidget {
  final String imagePath;

  const ImageViewScreen({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Evidence Image"),
      ),

      body: Center(
        child: InteractiveViewer(
          minScale: 1,
          maxScale: 5,
          child: Image.file(
            File(imagePath),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}