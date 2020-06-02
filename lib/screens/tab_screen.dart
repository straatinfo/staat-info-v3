import 'package:flutter/material.dart';
import 'package:straatinfoflutter/screens/registration_screen.dart';
import 'package:straatinfoflutter/screens/sampleCountries.dart';


class TabScreen extends StatelessWidget {

  static const String id = 'tab_screen';
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Straat.Info'),
          backgroundColor: Color(0xff4c6883),
          bottom: TabBar(
            unselectedLabelColor: Colors.white,

            indicator: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              color: Colors.green,
            ),
            tabs: <Widget>[
              Tab(text: ('DATA')),
              Tab(text: ('REPORTER')),
              Tab(text: ('TEAM')),
            ],
          ),
        ),
      body: TabBarView(
          children: [
            Container(
              child: RegistrationScreen(),
            ),
            Container(
              child: SampleCountries(),
            ),
            Container(
              child: SampleCountries(),
            ),
          ]),
      ),
    );
  }
}
