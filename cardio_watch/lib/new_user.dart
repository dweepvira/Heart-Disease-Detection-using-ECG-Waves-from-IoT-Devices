import 'package:cardio_watch/edit_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:permission_handler/permission_handler.dart';

class NewUserScreen extends StatefulWidget {
  const NewUserScreen({super.key});

  @override
  State<NewUserScreen> createState() => _NewUserScreenState();
}

class _NewUserScreenState extends State<NewUserScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Center(
              child: SizedBox(
                child: Image.asset('assets/sign_up.png'),
              ),
            ),
            const Text(
              'CardioWatch',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            // const SizedBox(height: 5),
            const Text(
              'Your heart health companion.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'Take control of your well-being. Sign up for Cardio Watch and gain insights into your heart health.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _signInWithGoogle,
              icon: SvgPicture.asset(
                'assets/google_logo.svg', // Path to your SVG file
              ),
              label: const Text(
                'Sign In using Google',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5B6CFF), // Background color
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _requestLocationPermission() async {
    var locationStatus = await Permission.locationWhenInUse.request();
    var bluetoothStatus = await Permission.bluetooth.request();

    if (locationStatus == PermissionStatus.granted &&
        bluetoothStatus == PermissionStatus.granted) {
      // Permission granted, start discovery
      print("All settings granted");
      // _startDiscovery();
    } else if (locationStatus == PermissionStatus.permanentlyDenied &&
        bluetoothStatus == PermissionStatus.permanentlyDenied) {
      // Permission permanently denied, show a dialog to explain and guide the user to settings
      openAppSettings(); // Function to open app settings (implementation shown later)
    } else {
      // Handle other permission statuses (optional)
    }
  }

  void _signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    // Sign out from Google if already signed in
    await googleSignIn.signOut();

    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        final UserCredential authResult =
            await FirebaseAuth.instance.signInWithCredential(credential);
        final User? user = authResult.user;
      }

      await _requestLocationPermission();
      // Navigate to HomeScreen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => EditProfileView(
            userCredential: googleSignInAccount,
          ), //userName: user.displayName ?? ''
        ),
      );
    } catch (e) {
      print('Error signing in with Google: $e');
    }
  }
}
