// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/account_screen.dart';
import 'screens/home_screen.dart';
import 'screens/phone_screen.dart';
import 'screens/profile_screen.dart';
import 'firebase_options.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MedGo());
}

class MedGo extends StatelessWidget {
   MedGo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MedGo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff4682A9),
        scaffoldBackgroundColor: Color(0xFFF3F4F6),
      ),
      home: AccountScreen(),
      routes: {
        '/Home': (context) =>  HomeScreen(),
        '/Account': (context) => AccountScreen(),
        '/Phone': (context) => PhoneScreen(),
        '/Profile': (context) {
          return ProfileScreen();
        },
      },
    );
  }
}
