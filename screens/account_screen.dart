// account_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool _isSigningIn = false;
  String? _error;
  String _userType = 'user'; // Default user type
  final googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isSigningIn = true;
      _error = null;
    });

    try {
      // Step 1: Sign in with Google
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Sign-in was cancelled by user');
      }

      // Step 2: Get authentication details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Print credentials for debugging
      debugPrint('Access Token: ${googleAuth.accessToken}');
      debugPrint('ID Token: ${googleAuth.idToken}');

      // Step 3: Create Firebase credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Step 4: Sign in to Firebase
      await FirebaseAuth.instance.signInWithCredential(credential);

      debugPrint('Successfully signed in with Google!');

      // Redirect on success
      if (mounted) {
        // Pass the user type to the next screen
        Navigator.pushNamed(context, '/Phone', arguments: _userType);
      }
    } catch (e) {
      debugPrint('Google Sign-In Error: $e');
      setState(() {
        _isSigningIn = false;
        _error = 'Failed to sign in with Google';
      });

      if (e is FirebaseAuthException) {
        debugPrint('Firebase Error Code: ${e.code}');
        debugPrint('Firebase Error Message: ${e.message}');
      }
    } finally {
      if (mounted && _isSigningIn) {
        setState(() => _isSigningIn = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Card(
            elevation: 4,
            margin: const EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.security, size: 48, color: Colors.blue),
                  const SizedBox(height: 16),
                  const Text('Secure Access',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Sign in to access your account',
                      style: TextStyle(color: Colors.grey[600])),
                  const SizedBox(height: 24),
                  DropdownButton<String>(
                    value: _userType,
                    items: const [
                      DropdownMenuItem(
                        value: 'user',
                        child: Text('User'),
                      ),
                      DropdownMenuItem(
                        value: 'pharmacy',
                        child: Text('Pharmacy'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _userType = value!;
                      });
                    },
                  ),
                  if (_error != null) ...[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(_error!,
                          style: TextStyle(color: Colors.red[700])),
                    ),
                  ],
                  FilledButton(
                    onPressed: _isSigningIn ? null : _signInWithGoogle,
                    child: _isSigningIn
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.login),
                              SizedBox(width: 8),
                              Text('Sign in with Google'),
                            ],
                          ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'By continuing, you agree to our Terms and Privacy Policy',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
