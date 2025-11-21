import 'dart:async';

import 'package:cardio_watch/firebase_options.dart';
import 'package:cardio_watch/new_user.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase is successfully connected');
  } catch (e) {
    print('Failed to connect to Firebase: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splash Screen',
      theme: ThemeData(
        primarySwatch: Colors.green,
        textTheme: GoogleFonts.lexendTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 1, milliseconds: 900),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const NewUserScreen())));
    // Timer(
    //     const Duration(seconds: 1, milliseconds: 900),
    //     () => Navigator.pushReplacement(context,
    //         MaterialPageRoute(builder: (context) => const FindDeviceView())));
  }

  @override
  Widget build(BuildContext context) {
    return Lottie.asset('assets/splash_animation.json');
  }
}
