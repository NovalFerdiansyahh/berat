import 'package:berat/pages/halaman_login.dart';
import 'package:berat/pages/splash_screen.dart';
import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      theme: ThemeData(fontFamily: "Montserrat-Regular"),
    );
  }
}
