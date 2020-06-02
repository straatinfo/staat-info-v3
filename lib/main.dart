import 'package:flutter/material.dart';
import 'package:straatinfoflutter/screens/enter_code_screen.dart';
import 'package:straatinfoflutter/screens/login_screen.dart';
import 'package:straatinfoflutter/screens/registration_screen.dart';
import 'package:straatinfoflutter/screens/tab_screen.dart';
import 'package:straatinfoflutter/screens/welcome_screen.dart';



void main() {
  runApp(StraatInfo());
}

class StraatInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: EnterCodeScreen.id,
      routes: {
        EnterCodeScreen.id: (context) => EnterCodeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        TabScreen.id: (context) => TabScreen(),

      },
    );
  }
}

