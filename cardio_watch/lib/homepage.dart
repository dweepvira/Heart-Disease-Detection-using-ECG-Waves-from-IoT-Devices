import 'package:cardio_watch/find_devices.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key, required this.userCredential});

  final GoogleSignInAccount? userCredential;

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 20.0,
                    backgroundImage:
                        NetworkImage(widget.userCredential?.photoUrl ?? ''),
                  ),
                  Text(
                    'Hello, ${widget.userCredential?.displayName}!',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Icon(
                    Icons.logout,
                    color: Colors.white,
                    size: 20.0,
                  ),
                ],
              ),
              // const SizedBox(height: 280.0),
              const Column(
                children: [
                  Text(
                    'Your Heart condition is',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    'HEALTHY',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 100.0),
              ElevatedButton.icon(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FindDeviceView()),
                  );
                },
                icon: const Icon(
                  Icons.health_and_safety,
                  color: Colors.white,
                  size: 30.0,
                ),
                label: const Text(
                  'Take A Test',
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  backgroundColor: const Color(0xFF5B6CFF), // Background color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
