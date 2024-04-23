import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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

class getProfile {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.reference().child("users");

  Future<Map<String, String>?> getUserProfile() async {
    try {
      String? userId = await getUser();
      if (userId != null) {
        DataSnapshot dataSnapshot =
            await _databaseReference.child(userId).get();
        Map<dynamic, dynamic>? userData =
            dataSnapshot.value as Map<dynamic, dynamic>?;
        if (userData != null) {
          String? fullName = userData['fullName'] as String?;
          String? address = userData['address'] as String?;
          String? phoneNumber = userData['phoneNumber'] as String?;

          Map<String, String> userProfile = {
            'fullName': fullName ?? '',
            'address': address ?? '',
            'phoneNumber': phoneNumber ?? '',
          };

          return userProfile;
        } else {
          // Handle null user data
          return null;
        }
      } else {
        // Handle null userId
        return null;
      }
    } catch (e) {
      print(e);
      // Handle errors
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
  }else{
  return('error');
  }
}
