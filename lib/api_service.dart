import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // آدرس سرور شما در ایران (بدون نیاز به فیلترشکن)
  static const String baseUrl = 'http://YOUR_IRANIAN_SERVER_IP_OR_DOMAIN/api';

  // ثبت نام یا ورود کاربر
  static Future?> loginOrRegister(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth.php'),
        body: {'username': username, 'password': password},
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print("خطا در اتصال به سرور: $e");
    }
    return null;
  }

  // دریافت پست‌ها
  static Future<List<dynamic>> getPosts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/posts.php'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print("خطا در دریافت پست‌ها: $e");
    }
    return [];
  }

  // ارسال پست جدید
  static Future<bool> createPost(String username, String caption, String imageBase64) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/add_post.php'),
        body: {
          'username': username,
          'caption': caption,
          'image': imageBase64,
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      print("خطا در ارسال پست: $e");
    }
    return false;
  }
}
