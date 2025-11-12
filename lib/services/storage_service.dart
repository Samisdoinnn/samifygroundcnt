import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_compress_flutter/image_compress_flutter.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  StorageService({
    FirebaseStorage? storage,
    ImagePicker? imagePicker,
  })  : _storage = storage ?? FirebaseStorage.instance,
        _imagePicker = imagePicker ?? ImagePicker();

  final FirebaseStorage _storage;
  final ImagePicker _imagePicker;

  Future<String?> uploadProfileImage(String userId) async {
    try {
      final image = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (image == null) return null;
      final compressedPath = await _compressImage(image.path);
      final ref = _storage.ref().child('profiles/$userId/profile.jpg');
      await ref.putFile(File(compressedPath));
      return ref.getDownloadURL();
    } catch (e) {
      // ignore: avoid_print
      print('Upload profile image error: $e');
      return null;
    }
  }

  Future<String?> uploadPostImage(String userId) async {
    try {
      final image = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (image == null) return null;
      final compressedPath = await _compressImage(image.path);
      final ref = _storage
          .ref()
          .child('posts/$userId/${DateTime.now().millisecondsSinceEpoch}.jpg');
      await ref.putFile(File(compressedPath));
      return ref.getDownloadURL();
    } catch (e) {
      // ignore: avoid_print
      print('Upload post image error: $e');
      return null;
    }
  }

  Future<String> _compressImage(String imagePath) async {
    final result = await ImageCompressFlutter.compressAndGetFile(
      imagePath,
      '${imagePath}_compressed.jpg',
      quality: 80,
      targetWidth: 800,
      targetHeight: 800,
    );
    return result.path;
  }
}


