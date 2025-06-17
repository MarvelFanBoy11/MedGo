// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/account_screen.dart';

void main() {
  runApp(MedGo());
}

class MedGo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MedGo',
      home: AccountScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
           '/Home' : (context) => HomeScreen(),
        },
    );
  }
}
