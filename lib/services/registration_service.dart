import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as io;
import 'package:path/path.dart' as path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class RegistrationService {
  static final FirebaseFirestore _database = FirebaseFirestore.instance;
  static final CollectionReference _usersCollection =
      _database.collection('users');
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> registerUser({
    required String uid, // Tambahkan parameter UID di sini
    required String fullName,
    required String address,
    required String phoneNumber,
    XFile? imageFile,
  }) async {
    try {
      String? imageUrl;
      if (imageFile != null) {
        imageUrl = await RegistrationService.uploadImage(imageFile);
      }
      Map<String, dynamic> newUser = {
        'fullName': fullName,
        'address': address,
        'phoneNumber': phoneNumber,
        'imageUrl': imageUrl,
      };
      await _usersCollection.doc(uid).set(newUser);
    } catch (e) {
      throw Exception('Gagal mendaftar: $e');
    }
  }

  static Future<String?> uploadImage(XFile imageFile) async {
    try {
      String fileName = path.basename(imageFile.path);
      Reference ref = _storage.ref().child('image/$fileName');
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

class SignOutService {
  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      print(getUser());
    } catch (e) {
      print('Error signing out: $e');
    }
  }
}

Future<String?> getUser() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    return user.uid;
  } else {
    return ('error');
  }
}