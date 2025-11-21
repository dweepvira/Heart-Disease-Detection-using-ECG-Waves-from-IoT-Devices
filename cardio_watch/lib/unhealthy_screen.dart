import 'package:flutter/material.dart';

class UnhealthyTestScreenView extends StatefulWidget {
  const UnhealthyTestScreenView({super.key});

  @override
  State<UnhealthyTestScreenView> createState() =>
      _UnhealthyTestScreenViewState();
}

class _UnhealthyTestScreenViewState extends State<UnhealthyTestScreenView> {
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
                    'UNHEALTHY',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Image.asset("assets/ecg2.png"),
                  ),
                  const Text(
                    "This is your ECG reading",
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "Diagnosed Condition: Premature atrial contraction",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "Premature atrial contraction (PAC), also known as atrial premature complexes (APC) or atrial premature beats (APB), are a common cardiac dysrhythmia characterized by premature heartbeats originating in the atria.",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ));
  }
}
