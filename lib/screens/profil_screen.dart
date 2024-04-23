import 'package:flutter/material.dart';
import 'package:tradetrove/services/registration_service.dart';

class ProfileScreen extends StatelessWidget {
  final getProfile GetProfile = getProfile(); // Instance of GetProfile class

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<Map<String, String>?>(
              future: GetProfile.getUserProfile(), // Menggunakan GetProfile untuk mendapatkan profil pengguna
              builder: (BuildContext context,
                  AsyncSnapshot<Map<String, String>?> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(); // Tampilkan loading spinner jika data belum selesai dimuat
                } else {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    // Jika data berhasil dimuat, tampilkan informasi profil
                    final Map<String, String>? userProfile = snapshot.data;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Full Name: ${userProfile?['fullName'] ?? ''}',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Address: ${userProfile?['address'] ?? ''}',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Phone Number: ${userProfile?['phoneNumber'] ?? ''}',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    );
                  } else {
                    return Text('No data available');
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
