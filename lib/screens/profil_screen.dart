import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tradetrove/authentication/login_screen.dart';
import 'package:tradetrove/authentication/update_profile.dart';
import 'package:tradetrove/services/registration_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final SignOutService signOutService = SignOutService();
  late User currentUser;
  late CollectionReference usersCollection;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  Future<void> getCurrentUser() async {
    currentUser = FirebaseAuth.instance.currentUser!;
    usersCollection = FirebaseFirestore.instance.collection('users');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(191, 149, 255, 1),
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/LogoTt.png',
              width: 40,
              height: 40,
            ),
            const SizedBox(width: 8),
            const Text(
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
        child: StreamBuilder<DocumentSnapshot>(
          stream: usersCollection.doc(currentUser.uid).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              final currentUserData =
                  snapshot.data!.data() as Map<String, dynamic>;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: currentUserData['imageUrl'] != null
                        ? NetworkImage(currentUserData['imageUrl'])
                        : const AssetImage('assets/images/default_avatar.png')
                            as ImageProvider,
                  ),
                  const SizedBox(height: 20),
                  _buildProfileField(
                    label: 'Full Name',
                    value: currentUserData['fullName'] ?? '',
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 20),
                  _buildProfileField(
                    label: 'Phone Number',
                    value: currentUserData['phoneNumber'] ?? '',
                    icon: Icons.phone,
                  ),
                  const SizedBox(height: 20),
                  _buildProfileField(
                    label: 'Address',
                    value: currentUserData['address'] ?? '',
                    icon: Icons.location_on,
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UpdateProfileScreen()),
                      );
                    },
                    child: const Text(
                      'Edit',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 40),
                      backgroundColor: const Color.fromRGBO(191, 149, 255, 1),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: ElevatedButton(
                      onPressed: () async {
                        await signOutService.signOut();
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Logout',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 40),
                        backgroundColor: const Color.fromRGBO(191, 149, 255, 1),
                      ),
                    ),
                  ),
                ],
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileField(
      {required String label, required String value, required IconData icon}) {
    return TextFormField(
      initialValue: value,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }
}
