import 'package:flutter/material.dart';
import 'package:mediact_app/module/authication/controller/auth_controller.dart';
import 'package:mediact_app/module/authication/view/register.dart';
import 'package:mediact_app/utility/textstyle.dart';
import 'package:get/get.dart';

class Login extends StatelessWidget {
  final LoginController loginController = Get.put(LoginController());

  Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
            colors: [
              Color.fromARGB(255, 213, 255, 165),
              Color.fromARGB(255, 247, 255, 237),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(
                              255,
                              173,
                              173,
                              173,
                            ).withOpacity(0.3),
                            blurRadius: 25,
                            spreadRadius: 10,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const CircleAvatar(
                        radius: 125,
                        backgroundImage: AssetImage(
                          'assets/images/sample-logo.png',
                        ),
                        backgroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(height: 25),
                    Column(
                      children: [
                        Text("ระบบจัดเวรพยาบาล", style: AppTextStyles.header()),
                        SizedBox(height: 5),
                        Text("สำหรับพยาบาล", style: AppTextStyles.subtitle()),
                      ],
                    ),
                    SizedBox(height: 60),
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Column(
                          children: [
                            TextField(
                              controller: loginController.emailController,
                              decoration: InputDecoration(
                                labelText: 'อีเมล',
                                hintText: 'กรอกอีเมลของคุณ',
                                prefixIcon: Icon(Icons.person),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.green),
                                ),
                                fillColor: Colors.white,
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 24, // ปรับความสูงตรงนี้
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            TextField(
                              controller: loginController.passwordController,
                              decoration: InputDecoration(
                                labelText: 'รหัสผ่าน',
                                hintText: 'กรอกรหัสผ่านของคุณ',
                                prefixIcon: Icon(Icons.lock),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.green),
                                ),
                                fillColor: Colors.white,
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 24, // ปรับความสูงตรงนี้
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 50),
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            "เข้าสู่ระบบ",
                            style: AppTextStyles.medium(color: Colors.white),
                          ),
                          onPressed: () {
                            loginController.login();
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Get.to(() => Register()); // 👈 ไปหน้า Register
                      },
                      child: Text(
                        "ยังไม่มีบัญชี? สมัครสมาชิก",
                        style: AppTextStyles.subtitle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
