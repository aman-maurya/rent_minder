import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rent_minder/screen/widgets/text_box.dart';
import 'package:rent_minder/appwrite/auth_api.dart';
import '../../utils/app_style.dart';
import '../widgets/button.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool loading = false;

  signIn() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Dialog(
            backgroundColor: Colors.transparent,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircularProgressIndicator(),
                ]),
          );
        });

    try {
      final AuthAPI appwrite = context.read<AuthAPI>();
      await appwrite.createEmailSession(
        email: emailController.text,
        password: passwordController.text,
      );
      Navigator.pop(context);
    } on AppwriteException catch (e) {
      Navigator.pop(context);
      showAlert(title: 'Login failed', text: e.message.toString());
    }
  }

  showAlert({required String title, required String text}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(text),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Ok'))
            ],
          );
        });
  }

  signInWithProvider(String provider) {
    try {
      context.read<AuthAPI>().signInWithProvider(provider: provider);
    } on AppwriteException catch (e) {
      showAlert(title: 'Login failed', text: e.message.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.appBgColor,
      body: Scaffold(
        body: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 60.0, horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text('Logo', style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            color: Styles.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 35
                        )
                    )),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Text('Login to your account', style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                      )
                  )),
                  const SizedBox(
                    height: 15,
                  ),
                  TextBoxWidget(
                    controller: emailController,
                    hintText: 'Email',
                    obscure: false,
                    textInputType: TextInputType.emailAddress,
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  TextBoxWidget(
                    controller: passwordController,
                    hintText: 'Password',
                    obscure: true,
                    textInputType: TextInputType.text,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ButtonWidget(
                    name: 'Login In',
                    onTap: signIn,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
