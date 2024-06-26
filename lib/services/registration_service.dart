import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tradetrove/models/model_user.dart';
import 'package:tradetrove/services/product.dart';

class RegistrationService {
  static final FirebaseFirestore _database = FirebaseFirestore.instance;
  static final CollectionReference _usersCollection =
      _database.collection('users');
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> registerUser({
    required String uid,
    required String fullName,
    required String address,
    required String phoneNumber,
    XFile? imageFile,
  }) async {
    try {
      String? imageUrl;
      if (imageFile != null) {
        imageUrl = await ProductService.uploadImage(imageFile, 'foto_profile');
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

  static Future<void> updateUser(MyUser myUser) async {
    Map<String, dynamic> updatedUser = {
      'fullName': myUser.fullName,
      'address': myUser.address,
      'phoneNumber': myUser.phoneNumber,
      'imageUrl': myUser.imageUrl,
    };
    await _usersCollection.doc(myUser.id).update(updatedUser);
  }

  static Future<String?> getCurrentUserName() async {
    final currentUserId = AuthService.currentUserId;
    if (currentUserId == null) return null;

    DocumentSnapshot userDoc = await _usersCollection.doc(currentUserId).get();
    if (userDoc.exists) {
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      return userData['fullName'];
    }
    return null;
  }
}

class SignOutService {
  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Menggunakan await untuk mendapatkan user yang telah sign out
      var user = await getUser();
      print('Current user after sign out: $user');
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

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static User? get currentUser => _auth.currentUser;
  static String? get currentUserId => _auth.currentUser?.uid;
}
