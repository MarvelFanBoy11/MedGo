// ignore_for_file: prefer_const_constructors, avoid_print, use_super_parameters, prefer_const_constructors_in_immutables

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
      ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();

  Future<void> _saveProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': _nameController.text,
          'email': _emailController.text,
          'address': _addressController.text,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile saved successfully!')),
        );
      } catch (e) {
        print('Failed to save profile: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save profile.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String phoneNumber = args['phoneNumber'];
    final String userType = args['userType'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        backgroundColor: const Color(0xff4682A9),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 60,
                backgroundColor: Color(0xff4682A9),
                child: Icon(Icons.person, size: 60, color: Colors.white),
              ),
              const SizedBox(height: 20),
              const Text(
                'Edit Profile',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Phone Number: $phoneNumber',
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
              Text(
                'User Type: $userType',
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff4682A9),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: const Text('Save Profile',
                    style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context, '/Home', (route) => false),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff4682A9),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: const Text('Continue to Home',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
