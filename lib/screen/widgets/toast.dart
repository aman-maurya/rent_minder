import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastWidget extends StatelessWidget {
  final String message;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final Toast toastLength;
  final ToastGravity gravity;

  const ToastWidget({
    super.key,
    required this.message,
    this.backgroundColor = Colors.black,
    this.textColor = Colors.white,
    this.fontSize = 16.0,
    this.toastLength = Toast.LENGTH_SHORT,
    this.gravity = ToastGravity.BOTTOM,
  });

  void _showToast() {
    Fluttertoast.showToast(
      msg: message,
      toastLength: toastLength,
      gravity: gravity,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: fontSize,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _showToast,
      child: Text('Show Toast'),
    );
  }
}
