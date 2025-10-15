import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:sankalp/views/Auth/LoginPage.dart';
import 'package:page_transition/page_transition.dart'; // Replace with your main screen file

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sankalp App',
      theme: ThemeData(
        fontFamily: 'Poppins',
        primarySwatch: Colors.blue,
      ),
      home: AnimatedSplashScreen(
        splash: Image.asset(
          'assets/images/Sankalp.png', // Replace with your splash screen image
          fit: BoxFit.contain,
        ),
        duration: 2500, // Duration of the splash screen in milliseconds
        splashTransition: SplashTransition.fadeTransition,
        pageTransitionType: PageTransitionType.fade,
        splashIconSize: MediaQuery.sizeOf(context).width *
            0.7, // Adjust the size of the splash image
        nextScreen: const LoginPage(), // Replace with your main screen widget
      ),
    );
  }
}
