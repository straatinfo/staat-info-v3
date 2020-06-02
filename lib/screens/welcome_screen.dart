import 'package:flutter/material.dart';


class WelcomeScreen extends StatelessWidget {
  static const String id = 'welcome_screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Image.asset(
                    'images/straat_info_icon.png',
                    width: 150.0,
                    height: 150.0,
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
