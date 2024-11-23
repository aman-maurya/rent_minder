import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class Styles{
  static Color primaryColor = const Color(0xFF6982f4);
  static Color appBgColor = Colors.grey.shade300;
  static Color bottomNavBarBg = Colors.deepPurple;
  static Color bottomNavBarTab = Colors.deepPurple.shade50;
  static Color bottomNavLabel = Colors.white;
  static Color colorBlack = const Color(0xff000000);
  static Color colorRed = const Color(0xffC44137);
  static TextStyle bottomNavBarTabBtn = GoogleFonts.openSans(
      textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17, color: Color(0xFF283593))
  );
  static TextStyle menuHeading = GoogleFonts.openSans(
    textStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF283593)
    ),
  );
  static TextStyle appBarHeading = GoogleFonts.openSans(
      textStyle: const TextStyle(
          color: Color(0xFF283593),
          fontWeight: FontWeight.w700,
          fontSize: 20
      )
  );
  static TextStyle listTextColor = GoogleFonts.openSans(
      textStyle: const TextStyle(
          color: Colors.black87,
          fontSize: 16,
          fontWeight: FontWeight.w700
      )
  );

  static TextStyle popUpMenuTextColor = GoogleFonts.openSans(
      textStyle: const TextStyle(
          color: Colors.black87,
          fontSize: 14,
          fontWeight: FontWeight.w700
      )
  );

  static TextStyle alertBoxBtn = GoogleFonts.openSans(
      textStyle: TextStyle(
          color: Styles.primaryColor,
          fontSize: 16,
          fontWeight: FontWeight.w700
      )
  );

  static TextStyle alertBoxMsg = GoogleFonts.openSans(
      textStyle: const TextStyle(
          color: Colors.black87,
          fontSize: 16,
          fontWeight: FontWeight.normal
      )
  );
}