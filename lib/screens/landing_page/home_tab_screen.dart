import 'package:flutter/material.dart';
import 'package:straatinfoflutter/screens/landing_page/tabs/public_tab.dart';
import 'package:straatinfoflutter/screens/landing_page/tabs/suspicious_tab.dart';
import 'package:straatinfoflutter/screens/landing_page/tabs/government_tab.dart';
import 'package:straatinfoflutter/screens/landing_page/tabs/team_tab.dart';
import 'package:straatinfoflutter/screens/landing_page/home_screen.dart';


class HomeTabScreen extends StatefulWidget {
  static const String id = 'home_tab_screen';
  @override
  _HomeTabScreenState createState() => _HomeTabScreenState();
}

class _HomeTabScreenState extends State<HomeTabScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff4c6883),
          automaticallyImplyLeading: false,
          title: Text('Straat.Info'),
          leading: GestureDetector(
            child: Icon(Icons.map,),
            onTap: () {
              Navigator.of(context).pushNamedAndRemoveUntil(HomeScreen.id, (Route<dynamic> route) => false);
            },
          ),
        ),
        body: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            shape: ContinuousRectangleBorder(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                  bottomLeft: Radius.circular(15.0),
                  bottomRight: Radius.circular(15.0),
                )
            ),
            title: Center(
              child: TabBar(
                isScrollable: true,
                labelColor: Color(0xff4c6883),
                unselectedLabelColor: Colors.grey,
                tabs: <Widget>[
                  Tab(icon: Icon(Icons.directions_car), text: 'Public',),
                  Tab(icon: Icon(Icons.warning), text: 'Suspicious',),
                  Tab(icon: Icon(Icons.account_balance), text: 'Government',),
                  Tab(icon: Icon(Icons.forum), text: 'Team',),
                ],
              ),
            ),
          ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(), // disable swipe navigation
            children: <Widget>[
              Container(child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: PublicTab(),
              ),),
              Container(child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SuspiciousTab(),
              ),),
              Container(child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GovernmentTab(),
              ),),
              Container(child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TeamTab(),
              ),),
            ],
          ),
        ),

      ),
    );
  }
}
