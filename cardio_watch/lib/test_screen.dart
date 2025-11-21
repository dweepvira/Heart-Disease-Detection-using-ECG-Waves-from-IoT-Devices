import 'package:flutter/material.dart';

class TestScreenView extends StatefulWidget {
  const TestScreenView({super.key});

  @override
  State<TestScreenView> createState() => _TestScreenViewState();
}

class _TestScreenViewState extends State<TestScreenView> {
  bool showText = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 30), () {
      if (mounted) {
        setState(() {
          showText = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return showText
        ? const Scaffold(
            backgroundColor: Colors.black,
            body: Center(
                child: Text(
              "Extracting and processing ECG data...",
              style: TextStyle(fontSize: 20, color: Colors.white),
            )),
          )
        : Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Your Heart condition is',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  const Text(
                    'HEALTHY',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Image.asset("assets/ecg.png"),
                  ),
                  const Text(
                    "This is your ECG reading",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ));
  }
}
