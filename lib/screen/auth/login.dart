import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rent_minder/screen/widgets/text_box.dart';

import '../../apis/Apis.dart';
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

  Future<void> signIn() async {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Logging in...')));
    try {
      await APIs.instance.loginEmailPassword(
        emailController.text,
        passwordController.text,
      ).then((result) {
        if(result) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Logged in')));
          Navigator.of(context).pushNamed('/menu');
        }else{
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid')));
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text(e.toString())));
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
