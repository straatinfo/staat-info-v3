import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:straatinfoflutter/providers/data.dart';
import 'package:straatinfoflutter/screens/landing_page/home_screen.dart';
import 'package:straatinfoflutter/screens/landing_page/feedback_screen.dart';
import 'package:straatinfoflutter/screens/landing_page/my_team_screen.dart';
import 'package:straatinfoflutter/screens/landing_page/profile_screen.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          SizedBox(
            height: 20.0,
          ),


          ListTile(
            leading: Icon(Icons.home, size: 37.0,),
            title: Text('Home', style: TextStyle(fontSize: 17.0),),
            onTap: () {
              Provider.of<Data>(context, listen: false).hideMarkersInGoogleMap(false);
              Navigator.of(context).pushNamedAndRemoveUntil(HomeScreen.id, (Route<dynamic> route) => false);
            },
          ),

          ListTile(
            leading: Icon(Icons.group, size: 37.0,),
            title: Text('My team', style: TextStyle(fontSize: 17.0),),
            onTap: () {
              Navigator.of(context).pushNamedAndRemoveUntil(MyTeamScreen.id, (Route<dynamic> route) => false);
            },
          ),

          ListTile(
            leading: Icon(Icons.person, size: 37.0,),
            title: Text('Profile', style: TextStyle(fontSize: 17.0),),
            onTap: () {
              Navigator.of(context).pushNamedAndRemoveUntil(ProfileScreen.id, (Route<dynamic> route) => false);
            },
          ),

          ListTile(
            leading: Icon(Icons.mail, size: 37.0,),
            title: Text('Feedback', style: TextStyle(fontSize: 17.0),),
            onTap: () {
              Navigator.of(context).pushNamedAndRemoveUntil(FeedbackScreen.id, (Route<dynamic> route) => false);
            },
          ),

          ListTile(
            leading: Icon(Icons.exit_to_app, size: 37.0,),
            title: Text('Logout', style: TextStyle(fontSize: 17.0),),
            onTap: () {
              print('Hello');
            },
          ),


        ],
      ),
//      child: Column(
//        children: <Widget>[
//          Container(
//            width: double.infinity,
//            padding: EdgeInsets.all(20.0),
//          )
//        ],
//      ),
    );
  }
}
