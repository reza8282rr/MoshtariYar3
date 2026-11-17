import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';
import 'main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final username = prefs.getString('username');

  runApp(MyApp(savedUsername: username));
}

class MyApp extends StatelessWidget {
  final String? savedUsername;
  MyApp({this.savedUsername});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ایرانیگرام',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Vazir', // می‌توانید فونت ایرانی وزیر را به دارایی‌ها اضافه کنید.
      ),
      debugShowCheckedModeBanner: false,
      home: savedUsername == null ? LoginScreen() : MainScreen(username: savedUsername!),
    );
  }
}
