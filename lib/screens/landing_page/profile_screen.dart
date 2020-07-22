import 'package:flutter/material.dart';
import 'package:straatinfoflutter/screens/landing_page/main_drawer.dart';
import 'package:straatinfoflutter/screens/landing_page/home_tab_screen.dart';

class ProfileScreen extends StatefulWidget {
  static const String id = 'my_profile_screen';
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff4c6883),
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text('My Profile-Straat.Info'),
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
        child: Text('My Profile Screen'),
      ),
    );
  }
}
