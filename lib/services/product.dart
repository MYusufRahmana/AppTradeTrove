import 'dart:io' as io;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tradetrove/models/product.dart';
import 'package:path/path.dart' as path;
import 'package:tradetrove/services/registration_service.dart';

class ProductService {
  static final FirebaseFirestore _database = FirebaseFirestore.instance;
  static final CollectionReference _productCollection = _database.collection('product');
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  // Tambah Data
  static Future<void> addProduct(Product product) async {
    final currentUserName = await RegistrationService.getCurrentUserName();
    final currentUserId = AuthService.currentUserId;
    if (currentUserName == null || currentUserId == null) {
      throw Exception('User not found');
    }

    Map<String, dynamic> newProduct = {
      'userName': currentUserName,
      'userId': currentUserId, // Tambahkan ini
      'merk': product.merk,
      'tahun': product.tahun,
      'jarakTempuh': product.jarakTempuh,
      'bahanBakar': product.bahanBakar,
      'warna': product.warna,
      'description': product.description,
      'kapasitasMesin': product.kapasitasMesin,
      'tipePenjual': product.tipePenjual,
      'harga': product.harga,
      'urlImage': product.urlImage,
      'lat': product.lat,
      'lng': product.lng,
      'created_at': FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
    };
    await _productCollection.add(newProduct);
  }

  // Menampilkan Data
  static Stream<List<Product>> getProductList() {
    return _productCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Product.fromMap(data, doc.id);
      }).toList();
    });
  }

  // Method Update Product
  static Future<void> updateProduct(Product product) async {
    Map<String, dynamic> updatedProduct = {
      'merk': product.merk,
      'tahun': product.tahun,
      'jarakTempuh': product.jarakTempuh,
      'bahanBakar': product.bahanBakar,
      'warna': product.warna,
      'description': product.description,
      'kapasitasMesin': product.kapasitasMesin,
      'tipePenjual': product.tipePenjual,
      'harga': product.harga,
      'urlImage': product.urlImage,
      'lat': product.lat,
      'lng': product.lng,
      'userName': product.userName,
      'userId': product.userId, // Tambahkan ini
      'created_at': product.createdAt,
      'updated_at': FieldValue.serverTimestamp(),
    };
    await _productCollection.doc(product.id).update(updatedProduct);
  }

  // Method Hapus Product
  static Future<void> deleteProduct(Product product) async {
    final currentUserName = await RegistrationService.getCurrentUserName();
    if (currentUserName == null) {
      throw Exception('User not found');
    }

    DocumentSnapshot docSnapshot = await _productCollection.doc(product.id).get();
    if (docSnapshot.exists) {
      String productOwner = docSnapshot['userName'];
      if (productOwner == currentUserName) {
        await _productCollection.doc(product.id).delete();
      } else {
        throw Exception('You do not have permission to delete this product');
      }
    } else {
      throw Exception('Product not found');
    }
  }

  // Upload Image
  static Future<String?> uploadImage(XFile imageFile, String childName) async {
    try {
      String fileName = path.basename(imageFile.path);
      Reference ref = _storage.ref().child('image/$childName/$fileName');
      UploadTask uploadTask;
      if (kIsWeb) {
        uploadTask = ref.putData(await imageFile.readAsBytes());
      } else {
        uploadTask = ref.putFile(io.File(imageFile.path));
      }
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      return null;
    }
  }
}
