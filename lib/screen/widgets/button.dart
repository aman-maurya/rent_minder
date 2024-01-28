import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/app_style.dart';

class ButtonWidget extends StatefulWidget {
  final Function()? onTap;
  final String name;

  const ButtonWidget({Key? key,
    this.onTap, required this.name
  }) : super(key: key);

  @override
  State<ButtonWidget> createState() => _ButtonWidget();

}

class _ButtonWidget extends State<ButtonWidget> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        alignment: Alignment.center,
        height: 50,
        decoration: BoxDecoration(
          color: Styles.primaryColor,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
            )
          ]
        ),
        child: Text(widget.name,
          style: GoogleFonts.openSans(
              textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700
              )
          ),
        ),
      ),
    );
  }
}
