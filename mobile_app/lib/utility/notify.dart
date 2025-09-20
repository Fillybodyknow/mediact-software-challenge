import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Notify {
  static Future<void> success(String message, {String title = 'สําเร็จ'}) {
    return _showDialog(
      message,
      title,
      Colors.green.shade600,
      Icons.check_circle,
    );
  }

  static Future<void> warning(String message, {String title = 'แจ้งเตือน'}) {
    return _showDialog(message, title, Colors.orange.shade700, Icons.warning);
  }

  static Future<void> alert(String message, {String title = 'เกิดข้อผิดพลาด'}) {
    return _showDialog(message, title, Colors.red.shade600, Icons.error);
  }

  static Future<void> _showDialog(
    String message,
    String title,
    Color color,
    IconData icon,
  ) {
    return Get.defaultDialog(
      title: title,
      titleStyle: TextStyle(color: color, fontWeight: FontWeight.bold),
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 60),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => Get.back(),
              child: const Text(
                'ปิด',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ),
      ],
      barrierDismissible: true,
    );
  }
}
