import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> uploadAudio(String filePath) async {
    try {
      final user = _auth.currentUser;

      if (user == null) {
        throw Exception("User not logged in");
      }

      final String fileName =
          "audio_${DateTime.now().millisecondsSinceEpoch}.m4a";

      final Reference ref = _storage
          .ref()
          .child("audio")
          .child(user.uid)
          .child(fileName);

      UploadTask uploadTask =
          ref.putFile(File(filePath));

      TaskSnapshot snapshot =
          await uploadTask;

      String downloadUrl =
          await snapshot.ref.getDownloadURL();

      print("Audio Uploaded Successfully");
      print(downloadUrl);

      return downloadUrl;
    } catch (e) {
      print("Upload Error: $e");
      rethrow;
    }
  }
}