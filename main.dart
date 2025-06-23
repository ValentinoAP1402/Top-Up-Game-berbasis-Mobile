import 'package:cuan_store/pages/halaman_validasi/welcome_page.dart';
import 'package:flutter/material.dart';
// import 'pages/halaman_validasi/register_page.dart';
// import 'pages/halaman_validasi/verification_page.dart';
// import 'pages/halaman_depan/topup_page.dart';
// import 'pages/halaman_depan/home_page.dart';
// import 'pages/halaman_depan/ff_topup_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TopUp Game',
      home: const WelcomePage(), // Ganti dengan halaman awal yang diinginkan
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
