import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:straatinfoflutter/providers/data.dart';
import 'package:straatinfoflutter/screens/registration/reporter_screen.dart';
import 'package:straatinfoflutter/screens/registration/data_screen.dart';
import 'package:straatinfoflutter/screens/registration/team_screen.dart';


class RegistrationTabScreen extends StatefulWidget {
  static const String id = 'registration_tab_screen';
  @override
  _RegistrationTabScreenState createState() => _RegistrationTabScreenState();
}

class _RegistrationTabScreenState extends State<RegistrationTabScreen> with SingleTickerProviderStateMixin {
  dynamic dataScreenForm;
  dynamic reporterScreenForm;

  final List<Tab> myTabs = <Tab> [
    Tab(text: 'DATA'),
    Tab(text: 'REPORTER'),
    Tab(text: 'TEAM'),
  ];

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    dataScreenForm = Provider.of<Data>(context).registrationData;
    reporterScreenForm = Provider.of<Data>(context).registrationReportValue;
    print('Registration tab rebuilding');
    return Scaffold(
      appBar: AppBar(
        title: Text('Straat.Info'),
        backgroundColor: Color(0xff4c6883),
        automaticallyImplyLeading: false,
      ),
      body: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Image.asset('images/straat_info_icon.png', width: 50.0, height: 50.0,),
          ),
          bottom: TabBar(
            onTap: (index) {
              if(dataScreenForm == null) {
                _tabController.animateTo(0);
              } else if(reporterScreenForm == null && index == 2) {
                  _tabController.animateTo(1);
              } else {
                _tabController.animateTo(index);
              }
            },
            controller: _tabController,
            unselectedLabelColor: Colors.black,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10)),
              color: Colors.green,
            ),
            tabs: myTabs,
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          physics: NeverScrollableScrollPhysics(), // disable swipe navigation
          children: <Widget>[
            Container(child: DataScreen(tabController: _tabController),),
            Container(child: ReporterScreen(tabController: _tabController),),
            Container(child: TeamScreen(),),
          ],
        ),
      ),
    );
  }
}
