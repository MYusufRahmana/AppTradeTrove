import 'package:flutter/material.dart';
import 'package:tradetrove/screens/profil_screen.dart';
import 'package:tradetrove/services/registration_service.dart'; // Import halaman profil

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final RegistrationService getUser = RegistrationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hi'),
      ),
      body: Center(
      ),

    );
  }


}
