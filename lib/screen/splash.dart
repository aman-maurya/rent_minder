import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../apis/Apis.dart';
import '../utils/app_style.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    getUserStatus();
  }

  void getUserStatus() async {
    await APIs.instance.isLoggedIn().then((isLoggedIn) {
      Timer(const Duration(seconds: 3), (){
        if (isLoggedIn) {
          Navigator.of(context).pushNamed('/menu');
        } else {
          Navigator.of(context).pushNamed('/login');
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.primaryColor,
      body: Center(
        child: Text('RentMinder', style: GoogleFonts.openSans(
            textStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 35
            )
        )),
      ),
    );
  }
}
