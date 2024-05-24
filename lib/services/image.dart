import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImageService {
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  static Future<String> uploadImage(XFile imageFile, String path) async {
    try {
      // Menggunakan timestamp sebagai nama file untuk menghindari duplikasi
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef = _storage.ref().child(path).child(fileName);

      // Mengunggah file
      UploadTask uploadTask = storageRef.putFile(File(imageFile.path));
      TaskSnapshot taskSnapshot = await uploadTask;

      // Mendapatkan URL unduhan gambar
      return await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Gagal mengunggah gambar: $e');
    }
  }
}
