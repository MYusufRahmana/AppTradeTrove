
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tradetrove/authentication/login_screen.dart';
import 'package:tradetrove/screens/home_screen.dart';
import 'package:tradetrove/screens/splash_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(Duration(seconds: 3)),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primaryColor: Colors.cyan.shade900, 
                fontFamily: 'Lato'), 
          home: SplashScreen());
        } else {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                primaryColor: Colors.cyan.shade900, 
                fontFamily: 'Lato'),
            home: LoginScreen(),
          );
        }
      },
    );
  }
}