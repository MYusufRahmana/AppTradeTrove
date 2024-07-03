import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tradetrove/authentication/login_screen.dart';
import 'package:tradetrove/authentication/update_profile.dart';
import 'package:tradetrove/services/registration_service.dart';
import 'package:tradetrove/services/theme.dart';

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
    final themeService = Provider.of<ThemeService>(context);
    final isDarkMode = themeService.isDarkMode;

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
              return SingleChildScrollView(
                child: Column(
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
                      isDarkMode: isDarkMode,
                    ),
                    const SizedBox(height: 20),
                    _buildProfileField(
                      label: 'Phone Number',
                      value: currentUserData['phoneNumber'] ?? '',
                      icon: Icons.phone,
                      isDarkMode: isDarkMode,
                    ),
                    const SizedBox(height: 20),
                    _buildProfileField(
                      label: 'Address',
                      value: currentUserData['address'] ?? '',
                      icon: Icons.location_on,
                      isDarkMode: isDarkMode,
                    ),
                    const SizedBox(height: 20),
                    Consumer<ThemeService>(
                      builder: (context, themeService, child) {
                        return SwitchListTile(
                          title: const Text('Mode Gelap'),
                          value: themeService.isDarkMode,
                          onChanged: (value) {
                            themeService.toggleTheme();
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const UpdateProfileScreen()),
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
                    const SizedBox(height: 20),
                    ElevatedButton(
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
                    const SizedBox(height: 20),
                  ],
                ),
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
      {required String label,
      required String value,
      required IconData icon,
      required bool isDarkMode}) {
    return TextFormField(
      initialValue: value,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        prefixIcon: Icon(icon, color: isDarkMode ? Colors.white : Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: isDarkMode ? Colors.grey[850] : Colors.grey[200],
      ),
      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
    );
  }
}