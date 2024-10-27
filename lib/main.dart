import 'package:flutter/material.dart';
import 'package:pingme/pages/homepage.dart';

void main() {
  runApp(const PingMeApp());
}

class PingMeApp extends StatelessWidget {
  const PingMeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PingMe',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}
