import 'package:flutter/material.dart';
import 'package:straatinfoflutter/screens/enter_code_screen.dart';

void main() {
  runApp(StraatInfo());
}

class StraatInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: EnterCodeScreen.id,
      routes: {
        EnterCodeScreen.id: (context) => EnterCodeScreen()
      },
    );
  }
}
