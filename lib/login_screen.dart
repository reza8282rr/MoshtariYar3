import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';
import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _login() async {
    setState(() => _isLoading = true);
    final result = await ApiService.loginOrRegister(
      _usernameController.text,
      _passwordController.text,
    );
    setState(() => _isLoading = false);

    if (result != null && result['status'] == 'success') {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', _usernameController.text);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen(username: _usernameController.text)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطا در ورود! اطلاعات را بررسی کنید.', textDirection: TextDirection.rtl)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'اینستاگرام ایرانی',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, fontFamily: 'Vazir'),
            ),
            SizedBox(height: 40),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'نام کاربری', border: OutlineInputBorder()),
              textDirection: TextDirection.ltr,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'رمز عبور', border: OutlineInputBorder()),
              obscureText: true,
              textDirection: TextDirection.ltr,
            ),
            SizedBox(height: 24),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,
                    child: Text('ورود / ثبت‌نام'),
                    style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
                  ),
          ],
        ),
      ),
    );
  }
}
