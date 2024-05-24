import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> createProduct({
    required String uid,
    required String merk,
    required String tahun,
    required String jarakTempuh,
    required String bahanBakar,
    required String warna,
    required String description,
    required String kapasitasMesin,
    required String tipePenjual,
    required String harga,
    XFile? imageFile,
  }) async {
    try {
      String imageUrl = '';
      if (imageFile != null) {
        final storageRef = _storage.ref().child('products/${imageFile.name}');
        await storageRef.putFile(File(imageFile.path));
        imageUrl = await storageRef.getDownloadURL();
      }

      await _firestore.collection('products').add({
        'uid': uid,
        'merk': merk,
        'tahun': tahun,
        'jarakTempuh': jarakTempuh,
        'bahanBakar': bahanBakar,
        'warna': warna,
        'description': description,
        'kapasitasMesin': kapasitasMesin,
        'tipePenjual': tipePenjual,
        'harga': harga,
        'imageUrl': imageUrl,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Error creating product: $e');
    }
  }
}
