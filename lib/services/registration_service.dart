import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class RegistrationService {
  final DatabaseReference _database =
      FirebaseDatabase.instance.ref().child('users');

  Future<void> registerUser({
    required String fullName,
    required String address,
    required String phoneNumber,
  }) async {
    try {
      // Dapatkan UID pengguna yang saat ini terautentikasi
      String uid = FirebaseAuth.instance.currentUser!.uid;

      // Simpan informasi tambahan pengguna ke dalam Realtime Database
      await _database.child(uid).set({
        'fullName': fullName,
        'address': address,
        'phoneNumber': phoneNumber,
      });
    } catch (e) {
      throw Exception('Gagal mendaftar: $e');
    }
  }
}
