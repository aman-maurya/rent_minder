import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rent_minder/screen/amenities.dart';
import 'package:rent_minder/screen/auth/login.dart';
import 'package:rent_minder/screen/auth/signup.dart';
import 'package:rent_minder/screen/splash.dart';
import 'package:rent_minder/screen/widgets/bottom_nav.dart';
import 'package:rent_minder/screen/menu.dart';
import 'package:appwrite/appwrite.dart';
import 'package:rent_minder/constants/credentials.dart';

Client client = Client();

void main() {
  client.setEndpoint(Credentials.APIEndpoint)
      .setProject(Credentials.ProjectID)
      .setSelfSigned(status: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      routes: {
        '/login': (BuildContext context) => const Login(),
        '/signup': (BuildContext context) => const SignUp(),
        '/menu': (BuildContext context) => const Menu(),
        '/amenities': (BuildContext context) => const Amenities(),
      },
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        // textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
        textTheme: GoogleFonts.openSansTextTheme(Theme.of(context).textTheme),
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const SplashView(),
    );
  }
}
