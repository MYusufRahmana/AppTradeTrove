import 'dart:io' as io;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tradetrove/models/comment.dart';
import 'package:tradetrove/models/favorite.dart';
import 'package:tradetrove/models/product.dart';
import 'package:path/path.dart' as path;
import 'package:tradetrove/services/registration_service.dart';

class ProductService {
  static final FirebaseFirestore _database = FirebaseFirestore.instance;
  static final CollectionReference _productCollection =
      _database.collection('product');
  static final CollectionReference _commentCollection =
      _database.collection('comments');
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
      'userId': currentUserId,
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
      'userId': product.userId,
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

    DocumentSnapshot docSnapshot =
        await _productCollection.doc(product.id).get();
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

  // Menambah Komentar
   static Future<void> addComment(Comment comment) async {
    await _commentCollection.add(comment.toMap());
  }

    static Stream<List<Comment>> getProductComments(Product product) {
    return _commentCollection.where('productId', isEqualTo: product.id).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Comment.fromMap(data, doc.id);
      }).toList();
    });
  }

  static Future<void> deleteComment(String commentId) async {
    await _commentCollection.doc(commentId).delete();
  }

  // Di dalam class ProductService

// Menambahkan Favorit
static Future<void> addFavorite(Favorite favorite) async {
  await _database.collection('favorites').add(favorite.toMap());
}

// Menghapus Favorit
static Future<void> removeFavorite(String productId, String userId) async {
  QuerySnapshot snapshot = await _database
      .collection('favorites')
      .where('productId', isEqualTo: productId)
      .where('userId', isEqualTo: userId)
      .get();

  snapshot.docs.forEach((doc) {
    doc.reference.delete();
  });
}

static Future<bool> isProductFavoritedByUser(String productId, String userId) async {
  QuerySnapshot snapshot = await _database
      .collection('favorites')
      .where('productId', isEqualTo: productId)
      .where('userId', isEqualTo: userId)
      .get();

  return snapshot.docs.isNotEmpty;
}

static Stream<List<Product>> getFavoriteProductsForUser(String userId) {
  return _database
      .collection('favorites')
      .where('userId', isEqualTo: userId)
      .snapshots()
      .asyncMap((snapshot) async {
        List<Product> favoriteProducts = [];
        for (var doc in snapshot.docs) {
          String productId = doc['productId'];
          DocumentSnapshot productSnapshot = await _productCollection.doc(productId).get();
          if (productSnapshot.exists) {
            favoriteProducts.add(Product.fromMap(productSnapshot.data() as Map<String, dynamic>, productSnapshot.id));
          }
        }
        return favoriteProducts;
      });
}


  
}
