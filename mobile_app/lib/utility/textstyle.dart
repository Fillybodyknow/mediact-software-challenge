import 'package:flutter/material.dart';

class AppTextStyles {
  // Large
  static TextStyle large({Color color = Colors.black}) {
    return TextStyle(fontSize: 24, color: color);
  }

  // Medium
  static TextStyle medium({Color color = Colors.black}) {
    return TextStyle(fontSize: 18, color: color);
  }

  // Small
  static TextStyle small({Color color = Colors.black}) {
    return TextStyle(fontSize: 14, color: color);
  }

  // Bold
  static TextStyle bold({Color color = Colors.black}) {
    return TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color);
  }

  // Italic
  static TextStyle italic({Color color = Colors.black}) {
    return TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: color);
  }

  // Subtitle
  static TextStyle subtitle({
    Color color = const Color.fromARGB(255, 124, 124, 124),
  }) {
    return TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: color);
  }

  // Header
  static TextStyle header({Color color = Colors.black}) {
    return TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: color,
      fontFamily: 'Roboto',
    );
  }
}
