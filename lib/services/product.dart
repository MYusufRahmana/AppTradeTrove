
import 'dart:io' as io;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tradetrove/models/product.dart';
import 'package:path/path.dart' as path;

class ProductService {
  static final FirebaseFirestore _database = FirebaseFirestore.instance;
  static final CollectionReference _productCollection =
      _database.collection('product');
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  //Tambah Data
  static Future<void> addProduct(Product product) async {
    Map<String, dynamic> newProduct = {
      'merk': product.merk,
      'tahun': product.tahun,
      'jarakTempuh': product.jarakTempuh,
      'bahanBakar': product.bahanBakar,
      'warna': product.warna,
      'description': product.description,
      'kapasitasMesin': product.kapasitasMesin,
      'tipePenjual': product.tipePenjual,
      'harga': product.harga,
      'image_Url': product.urlImage,
      'created_at': FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
    };
    await _productCollection.add(newProduct);
  }

  //Menampilkan Data
   static Stream<List<Product>> getProductList() {
    return _productCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Product(
          id: doc.id,
          merk: data['merk'],
          tahun: data['tahun'],
          jarakTempuh: data['jarakTempuh'],
          bahanBakar: data['bahanBakar'],
          warna: data['warna'],
          description: data['description'],
          kapasitasMesin: data['kapasitasMesin'],
          tipePenjual: data['tipePenjual'],
          harga: data['harga'],
          urlImage: data['image_Url'],
          createdAt: data['created_at'] != null
              ? data['created_at'] as Timestamp
              : null,
          updatedAt: data['updated_at'] != null
              ? data['updated_at'] as Timestamp
              : null,
        );
      }).toList();
    });
  }

    // Method Update Product
    static Future<void> updateNote(Product product) async {
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
      'image_Url': product.urlImage,
      'created_at': product.createdAt,
      'updated_at': FieldValue.serverTimestamp(),
    };
    await _productCollection.doc(product.id).update(updatedProduct);
  }

  //Method Hapus Product
    static Future<void> deleteProduct(Product product) async {
    await _productCollection.doc(product.id).delete();  }

    //Upload Image

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
