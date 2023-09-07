import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IconWidget extends StatelessWidget {
  String name;
  String icon;
  String screenName;
  Color bgColor;
  Color iconColor;
  IconWidget({
    super.key, required this.name,
    required this.icon, required this.bgColor,
    required this.iconColor,
    required this.screenName
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)
        ), padding: const EdgeInsets.all(0),
        textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontStyle: FontStyle.normal),
      ),
      onPressed: () {
        Navigator.of(context).pushNamed(screenName, arguments: {
          'title': name
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 50,
            child: Image.asset(icon, color: iconColor,),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width > 700 ? 10 : 8,
          ),
          Text(name, style: GoogleFonts.openSans(
              textStyle: TextStyle(
                  color: iconColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w700
              )))
        ],
      ),
    );
  }
}
