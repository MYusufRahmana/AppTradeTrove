import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tradetrove/navbar.dart';
import 'package:tradetrove/screens/home_screen.dart';
import 'package:tradetrove/services/registration_service.dart';
import 'registrasi_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
    final RegistrationService getUser=RegistrationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logoTt.png', // Ganti dengan path gambar logo Anda
                width: 200, // Sesuaikan lebar logo
                height: 200, // Sesuaikan tinggi logo
              ),
              const SizedBox(height: 16.0),
              Container( // Bar input email
                width: MediaQuery.of(context).size.width * 0.8, // Lebar 80% dari lebar layar
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                     labelStyle: TextStyle(color: Colors.deepPurple[500]), // Warna teks label email
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)), // Membuat border oval
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Container( // Bar input password
                width: MediaQuery.of(context).size.width * 0.8, // Lebar 80% dari lebar layar
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.deepPurple[500]), // Warna teks label password
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)), // Membuat border oval
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                child: const Text('Login'),
                onPressed: () {
                  _login();
                },
              ),
              const SizedBox(height: 8.0),
              TextButton(
                child: const Text('Belum punya akun? Daftar di sini'),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const RegistrationScreen()));
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  void _login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);

      if (mounted) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => Navbar()));
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message!)));
      }
    }
  }
}
