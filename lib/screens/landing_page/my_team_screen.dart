import 'package:flutter/material.dart';
import 'package:straatinfoflutter/screens/landing_page/main_drawer.dart';
import 'package:straatinfoflutter/screens/landing_page/home_tab_screen.dart';

class MyTeamScreen extends StatefulWidget {
  static const String id = 'my_team_screen';
  @override
  _MyTeamScreenState createState() => _MyTeamScreenState();
}

class _MyTeamScreenState extends State<MyTeamScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff4c6883),
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text('My Team'),
          ],
        ),
        leading: GestureDetector(
          child: Icon(Icons.chat_bubble, color: Colors.white,),
          onTap: () {
            Navigator.pushNamed(context, HomeTabScreen.id);
          },
        ),
      ),
      endDrawer: MainDrawer(),
      body: Container(
        child: Text('My Team Screen'),
      ),
    );
  }
}
