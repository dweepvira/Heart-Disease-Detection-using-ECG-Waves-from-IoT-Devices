import 'package:cardio_watch/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key, required this.userCredential});

  final GoogleSignInAccount? userCredential;

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  bool _hasHighBloodPressure = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20.0, 16, 20.0, 16),
          children: <Widget>[
            const Center(
              child: Text(
                'Creeate Profile',
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            const SizedBox(height: 16.0),
            Center(
              child: CircleAvatar(
                radius: 60.0,
                backgroundImage:
                    NetworkImage(widget.userCredential?.photoUrl ?? ''),
              ),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Name',
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 8.0),
            TextFormField(
              initialValue: widget.userCredential?.displayName ?? '',
              decoration: const InputDecoration(
                hintStyle: TextStyle(color: Colors.white),
                hintText: 'Your Name',
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24.0),
            const Text(
              'Gender',
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 8.0),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                    value: "Male",
                    child: Text("Male", style: TextStyle(color: Colors.grey))),
                DropdownMenuItem(
                    value: "Female",
                    child:
                        Text("Female", style: TextStyle(color: Colors.grey))),
                DropdownMenuItem(
                    value: "Non-Binary",
                    child: Text("Non-Binary",
                        style: TextStyle(color: Colors.grey))),
                DropdownMenuItem(
                    value: "Prefer not to say",
                    child: Text("Prefer not to say",
                        style: TextStyle(color: Colors.grey))),
              ],
              onChanged: (String? newValue) {
                setState(() {
                  _genderController.text = newValue ?? '';
                });
              },
              hint: const Text('Choose your gender',
                  style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Phone number',
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 8.0),
            TextFormField(
              controller: _phoneNumberController,
              decoration: const InputDecoration(
                hintText: 'Enter your phone number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Date of Birth',
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 8.0),
            GestureDetector(
              onTap: () {
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                ).then((pickedDate) {
                  if (pickedDate == null) return;
                  setState(() {
                    _dateOfBirthController.text =
                        DateFormat('dd/MM/yyyy').format(pickedDate);
                  });
                });
              },
              child: AbsorbPointer(
                child: TextFormField(
                  controller: _dateOfBirthController,
                  decoration: const InputDecoration(
                    hintText: 'DD/MM/YYYY',
                    hintStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            CheckboxListTile(
              title: const Text(
                'Do you have high blood pressure?',
                style: TextStyle(color: Colors.white),
              ),
              value: _hasHighBloodPressure,
              onChanged: (value) {
                setState(() {
                  _hasHighBloodPressure = value!;
                });
              },
              activeColor: const Color(0xFF5B6CFF),
              checkColor: Colors.white,
            ),
            const SizedBox(height: 24.0),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  backgroundColor: const Color(0xFF5B6CFF), // Background color
                  fixedSize: const Size(200, 40), // Makes the button smaller
                ),
                onPressed: () async {
                  // Save changes to Firestore

                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(widget.userCredential?.id)
                      .set({
                    'name': widget.userCredential?.displayName,
                    'gender': _genderController.text,
                    'phoneNumber': _phoneNumberController.text,
                    'dateOfBirth': _dateOfBirthController.text,
                    'hasHighBloodPressure': _hasHighBloodPressure,
                  });

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Profile created successfully!'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Okay!'),
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => HomePageView(
                                    userCredential: widget.userCredential,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text(
                  'Save changes',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
