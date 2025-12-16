import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_style.dart';

class ButtonWidget extends StatefulWidget {
  final Function()? onTap;
  final String name;
  final bool isDisabled; // New parameter for disabled state

  const ButtonWidget({
    super.key,
    this.onTap,
    required this.name,
    this.isDisabled = false, // Default value is false (enabled)
  });

  @override
  State<ButtonWidget> createState() => _ButtonWidget();
}

class _ButtonWidget extends State<ButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isDisabled ? null : widget.onTap, // Disable onTap if isDisabled is true
      child: Container(
        alignment: Alignment.center,
        height: 50,
        decoration: BoxDecoration(
          color: widget.isDisabled
              ? Styles.primaryColor.withValues(alpha: 0.5) // Dimmed color when disabled
              : Styles.primaryColor,
          borderRadius: BorderRadius.circular(6),
          boxShadow: widget.isDisabled
              ? [] // No shadow when disabled
              : [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
            ),
          ],
        ),
        child: Text(
          widget.name,
          style: GoogleFonts.openSans(
            textStyle: TextStyle(
              color: widget.isDisabled ? Colors.grey.shade300 : Colors.white, // Adjust text color when disabled
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
