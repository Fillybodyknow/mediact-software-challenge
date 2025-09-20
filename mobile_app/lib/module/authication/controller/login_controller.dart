import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mediact_app/utility/notify.dart';
import 'package:mediact_app/utility/https.dart';
import 'package:http/http.dart' as http;

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Map<String, dynamic>? LoginResponseData;

  Future<void> login() async {
    String loginendpoint = '${Https.developerUrl}/auth/login';

    try {
      final response = await http
          .post(
            Uri.parse(loginendpoint),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode({
              'email': emailController.text,
              'password': passwordController.text,
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        LoginResponseData = jsonDecode(response.body);
        final token = LoginResponseData!['token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await Notify.success(
          'ระบบจะนำพาคุณไปยังหน้าหลัก',
          title: 'เข้าสู่ระบบสําเร็จ',
        );
        Get.offAllNamed('/home');
      } else {
        final errorData = jsonDecode(response.body);
        Notify.alert('${errorData['error']}');
      }
    } catch (e) {
      Notify.alert('ไม่สามารถเชื่อมต่อเซิร์ฟเวอร์ได้: $e');
      print(e);
    }
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Get.offAllNamed('/login');
  }
}
