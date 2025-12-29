import 'package:flutter/material.dart';
import '../../utils/app_style.dart';

class TextBoxWidget extends StatefulWidget {
  const TextBoxWidget({super.key,
    required this.controller,
    required this.hintText,
    required this.textInputType,
    this.obscure = false,
    this.errorMaxLen = 1,
    this.validator,
    this.prefixIcon,
    this.actionKeyboard = TextInputAction.next,
    this.focusNode,
    this.maxLines = 1,
    this.minLines,
  });

  final TextEditingController controller;
  final String hintText;
  final TextInputType textInputType;
  final bool obscure;
  final int errorMaxLen;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final TextInputAction? actionKeyboard;
  final FocusNode? focusNode;
  final int maxLines;
  final int? minLines;

  @override
  State<TextBoxWidget> createState() => _TextBoxWidgetState();

}

class _TextBoxWidgetState extends State<TextBoxWidget> {

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        primaryColor: Styles.primaryColor,
      ),
      child: TextFormField(
        cursorColor: Styles.primaryColor,
        controller: widget.controller,
        validator: widget.validator,
        keyboardType: widget.textInputType,
        textInputAction: widget.actionKeyboard,
        focusNode: widget.focusNode,
        obscureText: widget.obscure,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        style: TextStyle(
            backgroundColor: Colors.white,
            color: Styles.colorBlack,
            fontSize: 16.0,
            fontWeight: FontWeight.w200,
            fontStyle: FontStyle.normal,
            letterSpacing: 1.2,
        ),
        decoration: InputDecoration(
          prefixIcon: widget.prefixIcon,
          hintText: widget.hintText,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(15),
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.0),
            borderSide: BorderSide.none,
          ),
          errorStyle: TextStyle(
            color: Styles.colorRed,
            fontSize: 15.0,
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.normal,
            letterSpacing: 1.2,
          ),
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 15.0,
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.normal,
            letterSpacing: 1.2,
          ),
          errorMaxLines: widget.errorMaxLen,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Styles.primaryColor),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Styles.colorRed),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Styles.colorRed),
          ),
        ),
      ),
    );
  }
}

