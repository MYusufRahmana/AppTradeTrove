import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class RegistrationService {
  final DatabaseReference _database =
      FirebaseDatabase.instance.reference().child('users');

  Future<void> registerUser({
    required String uid, // Tambahkan parameter UID di sini
    required String fullName,
    required String address,
    required String phoneNumber,
  }) async {
    try {
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
