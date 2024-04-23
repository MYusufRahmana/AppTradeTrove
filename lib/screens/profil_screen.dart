import 'package:flutter/material.dart';
import 'package:tradetrove/authentication/login_screen.dart';
import 'package:tradetrove/services/registration_service.dart';

class ProfileScreen extends StatelessWidget {
  final getProfile GetProfile = getProfile(); // Instance of GetProfile class
  final SignOutService signOutService = SignOutService(); // Instance of SignOutService class

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              // Tambahkan logika untuk logout di sini
              signOutService.signOut();
               Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const LoginScreen()));
              
            },
          ),
        ],
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
                        _buildProfileInfo(Icons.person, 'Full Name', userProfile?['fullName'] ?? ''),
                        _buildProfileInfo(Icons.location_on, 'Address', userProfile?['address'] ?? ''),
                        _buildProfileInfo(Icons.phone, 'Phone Number', userProfile?['phoneNumber'] ?? ''),
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

  Widget _buildProfileInfo(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 24,
            color: Colors.black54,
          ),
          SizedBox(width: 12),
          Column(
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
        ],
      ),
    );
  }
}
