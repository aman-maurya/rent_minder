import 'package:flutter/material.dart';

class TextBoxWidget extends StatelessWidget {
  const TextBoxWidget({Key? key, required this.controller,
    required this.hintText,
    required this.textInputType,
    required this.obscure}) : super(key: key);
  final TextEditingController controller;
  final String hintText;
  final TextInputType textInputType;
  final bool obscure;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.only(top: 0, left: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 7
          )
        ]
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: textInputType,
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(0),
          hintStyle: const TextStyle(
            height: 1
          )
        ),
      ),
    );
  }
}

