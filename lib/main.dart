import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:straatinfoflutter/screens/enter_code/enter_code_screen.dart';
import 'package:straatinfoflutter/screens/landing_page/home_screen.dart';
import 'package:straatinfoflutter/screens/login/login_screen.dart';
import 'package:straatinfoflutter/screens/registration/registration_tab_screen.dart';
import 'package:straatinfoflutter/screens/registration/terms_screen.dart';
import 'package:straatinfoflutter/providers/data.dart';
import 'package:straatinfoflutter/screens/landing_page/home_tab_screen.dart';
import 'package:straatinfoflutter/screens/landing_page/feedback_screen.dart';
import 'package:straatinfoflutter/screens/landing_page/my_team_screen.dart';
import 'package:straatinfoflutter/screens/landing_page/profile_screen.dart';

void main() {
  runApp(StraatInfo());
}

class StraatInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Data>(
      create: (context) => Data(),
      child: MaterialApp(
        initialRoute: EnterCodeScreen.id,
        routes: {
          EnterCodeScreen.id: (context) => EnterCodeScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          RegistrationTabScreen.id: (context) => RegistrationTabScreen(),
          TermsScreen.id: (context) => TermsScreen(),
          HomeScreen.id: (context) => HomeScreen(),
          HomeTabScreen.id: (context) => HomeTabScreen(),
          FeedbackScreen.id: (context) => FeedbackScreen(),
          MyTeamScreen.id: (context) => MyTeamScreen(),
          ProfileScreen.id: (context) => ProfileScreen(),

        },
      ),
    );
  }
}

