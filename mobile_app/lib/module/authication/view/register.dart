import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mediact_app/module/authication/controller/auth_controller.dart';
import 'package:mediact_app/module/authication/view/login.dart';
import 'package:mediact_app/utility/textstyle.dart';

class Register extends StatelessWidget {
  final RegisterController registerController = Get.put(RegisterController());

  Register({super.key});

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
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 100),
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
                  Text("สมัครสมาชิก", style: AppTextStyles.header()),
                  SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: registerController.nameController,
                          decoration: InputDecoration(
                            labelText: 'ชื่อ',
                            hintText: 'กรอกชื่อของคุณ',
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
                            contentPadding: EdgeInsets.symmetric(vertical: 20),
                          ),
                        ),
                        SizedBox(height: 15),
                        TextField(
                          controller: registerController.emailController,
                          decoration: InputDecoration(
                            labelText: 'อีเมล',
                            hintText: 'กรอกอีเมลของคุณ',
                            prefixIcon: Icon(Icons.email),
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
                            contentPadding: EdgeInsets.symmetric(vertical: 20),
                          ),
                        ),
                        SizedBox(height: 15),
                        Obx(
                          () => DropdownButtonFormField<String>(
                            initialValue: registerController.selectedRole.value,
                            items: const [
                              DropdownMenuItem(
                                value: 'nurse',
                                child: Text('พยาบาล'),
                              ),
                              DropdownMenuItem(
                                value: 'head_nurse',
                                child: Text('หัวหน้าพยาบาล'),
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                registerController.selectedRole.value = value;
                              }
                            },
                            decoration: InputDecoration(
                              labelText: 'เลือกบทบาท',
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
                                vertical: 20,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        TextField(
                          controller: registerController.passwordController,
                          obscureText: true,
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
                            contentPadding: EdgeInsets.symmetric(vertical: 20),
                          ),
                        ),
                        SizedBox(height: 15),
                        TextField(
                          controller:
                              registerController.verifyPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'ยืนยันรหัสผ่าน',
                            hintText: 'กรอกรหัสผ่านอีกครั้ง',
                            prefixIcon: Icon(Icons.lock_outline),
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
                            contentPadding: EdgeInsets.symmetric(vertical: 20),
                          ),
                        ),
                        SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              "สมัครสมาชิก",
                              style: AppTextStyles.medium(color: Colors.white),
                            ),
                            onPressed: () {
                              registerController.register();
                            },
                          ),
                        ),
                        SizedBox(height: 20),
                        TextButton(
                          onPressed: () {
                            Get.to(() => Login()); // 👈 กลับไปหน้า Login
                          },
                          child: Text(
                            "มีบัญชีแล้ว? เข้าสู่ระบบ",
                            style: AppTextStyles.subtitle(color: Colors.blue),
                          ),
                        ),
                        SizedBox(height: 50),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
