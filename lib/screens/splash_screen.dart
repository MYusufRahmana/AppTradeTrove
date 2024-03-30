import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const colorizeColors = [
      Color.fromRGBO(255, 0, 255,
          1), // Warna ungu cerah dengan ketebalan penuh (alpha = 1)
      Colors.white,
    ];

    const colorizeTextStyle = TextStyle(
      fontSize: 20.0,
      fontFamily: 'Lato',
    );

    return Scaffold(
      backgroundColor: Colors.cyan.shade900,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logoTt.png',
            ),
            SizedBox(
              width: 250.0,
              child: AnimatedTextKit(
                animatedTexts: [
                  ColorizeAnimatedText('Selamat Datang DiTradeTrove ',
                      textStyle: colorizeTextStyle, colors: colorizeColors),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
