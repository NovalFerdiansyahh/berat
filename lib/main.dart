import 'package:berat/pages/halaman_detail.dart';
import 'package:berat/pages/halaman_komentar.dart';

import 'package:berat/pages/halaman_favorit.dart';
import 'package:berat/pages/halaman_login.dart';
import 'package:berat/pages/halaman_utama.dart';
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
      home: LoginPage(),
      theme: ThemeData(fontFamily: "Montserrat-Regular"),
    );
  }
}
