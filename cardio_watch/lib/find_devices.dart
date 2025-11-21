import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:cardio_watch/unhealthy_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';

class FindDeviceView extends StatefulWidget {
  /// If true, discovery starts on page start, otherwise user must press action button.
  final bool start;

  const FindDeviceView({super.key, this.start = true});

  @override
  _FindDeviceView createState() => _FindDeviceView();
}

class _FindDeviceView extends State<FindDeviceView> {
  StreamSubscription<BluetoothDiscoveryResult>? _streamSubscription;
  List<BluetoothDiscoveryResult> results =
      List<BluetoothDiscoveryResult>.empty(growable: true);
  bool isDiscovering = false;

  _FindDeviceView();

  @override
  void initState() {
    _requestLocationPermission();
    FlutterBluetoothSerial.instance.cancelDiscovery();
    super.initState();
    isDiscovering = widget.start;
    if (isDiscovering) {
      _startDiscovery();
    }
  }

  Future<void> _requestLocationPermission() async {
    // var locationStatus = await Permission.location.request();
    var bluetoothStatus = await Permission.bluetoothConnect.request();
    await Permission.bluetoothScan.request();

    if (bluetoothStatus == PermissionStatus.granted) {
      // Permission granted, start discovery
      print("All settings granted");
      _startDiscovery();
    } else if (bluetoothStatus == PermissionStatus.permanentlyDenied) {
      // Permission permanently denied, show a dialog to explain and guide the user to settings
      openAppSettings(); // Function to open app settings (implementation shown later)
    } else {
      // Handle other permission statuses (optional)
    }
  }

  void _restartDiscovery() {
    setState(() {
      results.clear();
      isDiscovering = true;
    });

    _startDiscovery();
  }

  void _startDiscovery() {
    FlutterBluetoothSerial.instance.cancelDiscovery();
    _streamSubscription =
        FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      setState(() {
        final existingIndex = results.indexWhere(
            (element) => element.device.address == r.device.address);
        if (existingIndex >= 0) {
          results[existingIndex] = r;
        } else {
          results.add(r);

          ble_result
              .add({'name': r.device.name ?? "null", "id": r.device.address});
        }
      });
    });

    _streamSubscription!.onDone(() {
      setState(() {
        isDiscovering = false;
      });
    });
  }

  // @TODO . One day there should be `_pairDevice` on long tap on something... ;)

  List<Map<String, String>> ble_result = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: isDiscovering
            ? const Text('Discovering devices',
                style: TextStyle(color: Colors.white))
            : const Text('Discovered devices',
                style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          isDiscovering
              ? FittedBox(
                  child: Container(
                    margin: const EdgeInsets.all(16.0),
                    child: const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.replay, color: Colors.white),
                  onPressed: () {
                    _streamSubscription?.cancel();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FindDeviceView()));
                  },
                )
        ],
      ),
      body: ListView.builder(
        itemCount: ble_result.length,
        itemBuilder: (BuildContext context, index) {
          Map<String, String> result = ble_result[index];
          final device = result["name"];
          final address = result['id'];

          return ListTile(
            title:
                Text(device ?? "", style: const TextStyle(color: Colors.white)),
            subtitle: Text(address ?? "",
                style: const TextStyle(color: Colors.white)),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Device Connected'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          BluetoothConnection connection;
                          List<dynamic> arduinoInp = [];

                          connect(String address) async {
                            try {
                              connection =
                                  await BluetoothConnection.toAddress(address);
                              print('Connected to the device');

                              connection.input?.listen((Uint8List data) {
                                //Data entry point
                                print(ascii.decode(data));
                                connection.close();
                                // Stop listening after 1 print
                              });
                            } catch (exception) {
                              print('Cannot connect, exception occured');
                            }
                          }

                          connect(address ?? "");
                          for (List<dynamic> r in arduinoInp) {
                            print(r);
                          }
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const UnhealthyTestScreenView()));
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
