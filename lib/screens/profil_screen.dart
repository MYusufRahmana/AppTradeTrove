import 'package:flutter/material.dart';
import 'package:tradetrove/authentication/login_screen.dart';
import 'package:tradetrove/services/registration_service.dart';
import 'package:flutter/material.dart';
import 'package:tradetrove/services/registration_service.dart';

class ProfileScreen extends StatelessWidget {
  final getProfile GetProfile = getProfile(); // Instance of GetProfile class
  final SignOutService signOutService = SignOutService(); // Instance of SignOutService class

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple.shade500,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/LogoTt.png', // Ganti dengan lokasi logo Trade Trove Anda
              width: 40,
              height: 40,
            ),
            SizedBox(width: 8),
            Text(
              'Trade Trove',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<Map<String, String>?>(
              future: GetProfile.getUserProfile(),
              builder: (BuildContext context, AsyncSnapshot<Map<String, String>?> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    final Map<String, String>? userProfile = snapshot.data;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildProfileItem('Full Name', userProfile?['fullName'] ?? ''),
                        _buildDivider(),
                        _buildProfileItem('Address', userProfile?['address'] ?? ''),
                        _buildDivider(),
                        _buildProfileItem('Phone Number', userProfile?['phoneNumber'] ?? ''),
                        _buildDivider(),
                      ],
                    );
                  } else {
                    return Text('No data available');
                  }
                }
              },
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                // Tambahkan logika untuk tombol edit di sini
              },
              child: Text('Edit',
                style: TextStyle(color: Colors.white),),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 40),
                 backgroundColor: Colors.purple.shade400, 
              ),
            ),
            SizedBox(height: 5),
            ElevatedButton(
              onPressed: () {
                // Tambahkan logika untuk tombol logout di sini
                signOutService.signOut();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ));
              },
              child: Text('Logout',
                style: TextStyle(color: Colors.white),),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 40),
                 backgroundColor:Colors.purple.shade400, 
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      height: 1,
      color: Colors.grey[300],
    );
  }

  Widget _buildProfileItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}