// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PhoneScreen extends StatefulWidget {
  PhoneScreen({Key? key}) : super(key: key);

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  String? _verificationId;
  bool _codeSent = false;
  bool _isLoading = false;
  String? _error;

  Future<void> _sendVerificationCode() async {
    final phoneNumber = _phoneController.text;
    if (phoneNumber.length != 11) {
      setState(() {
        _error = 'Phone number must be 11 digits';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+20${phoneNumber}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-resolution on Android devices
          setState(() => _isLoading = false);
          await FirebaseAuth.instance.signInWithCredential(credential);
          _navigateToProfile();
        },
        verificationFailed: (FirebaseAuthException e) {
          setState(() {
            _isLoading = false;
            _error = 'Failed to send code: ${e.message}';
          });
          print('Firebase Error Code: ${e.code}');
          print('Firebase Error Message: ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _isLoading = false;
            _codeSent = true;
            _verificationId = verificationId;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() => _verificationId = verificationId);
        },
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'An unexpected error occurred';
      });
      print('Unexpected error: $e');
    }
  }

  Future<void> _verifyCode() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: _codeController.text,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      _navigateToProfile();
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Invalid verification code';
      });
    }
  }

 void _navigateToProfile() {
    final userType = ModalRoute.of(context)!.settings.arguments as String?;
    final phoneNumber = _phoneController.text;
    Navigator.pushNamed(
      context,
      '/Profile',
      arguments: {
        'phoneNumber': phoneNumber,
        'userType': userType ?? 'user',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8.0,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 20),
                  Text(
                    'Verify your phone number',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 30),
                  if (_error != null)
                    Text(
                      _error!,
                      style: TextStyle(color: Colors.red),
                    ),
                  if (!_codeSent)
                    TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Phone Number',
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                        prefixIcon: Icon(Icons.phone),
                      ),
                    ),
                  if (_codeSent)
                    TextField(
                      controller: _codeController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Verification Code',
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                        prefixIcon: Icon(Icons.lock),
                      ),
                    ),
                  SizedBox(height: 20),
                  if (!_codeSent)
                    ElevatedButton(
                      onPressed: _isLoading ? null : _sendVerificationCode,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff4682A9),
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      ),
                      child: _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                              'Send Code',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                    ),
                  if (_codeSent)
                    ElevatedButton(
                      onPressed: _isLoading ? null : _verifyCode,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff4682A9),
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      ),
                      child: _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                              'Verify Code',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                    ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
