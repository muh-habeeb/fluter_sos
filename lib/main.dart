import 'package:flutter/material.dart';
import 'package:pingme/pages/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isAlarmOn = prefs.getBool('isAlarmOn') ?? true;
  runApp(MyApp(isAlarmOn: isAlarmOn));
}

class MyApp extends StatelessWidget {
  final bool isAlarmOn;

  const MyApp({super.key, required this.isAlarmOn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PingMe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
