import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:straatinfoflutter/components/rounded_button.dart';
import 'package:straatinfoflutter/providers/data.dart';

class ReporterScreen extends StatefulWidget {
  final TabController tabController;
  ReporterScreen({this.tabController});
  @override
  _ReporterScreenState createState() => _ReporterScreenState();
}

class _ReporterScreenState extends State<ReporterScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[

              Text('Do you use Straat.info as Volunteer?',
                style: TextStyle(fontSize: 30.0),
                textAlign: TextAlign.left,
              ),

              RoundedButton(title: 'YES', color: Color(0xFF7dbf40), onPressed: () {
                Provider.of<Data>(context, listen: false).fillUpReporterData(true);
                widget.tabController.animateTo(2);
              }),
              RoundedButton(title: 'NO', color: Color(0xFF7dbf40), onPressed: () {
                Provider.of<Data>(context, listen: false).fillUpReporterData(false);
                widget.tabController.animateTo(2);
              }),
              SizedBox(height: 30.0,),
              Text('When you are volunteer, for example want to join a neighbourhood watch, then choose \"YES\". '
                  'When you are going to use this app as a professional, please choose \"NO\".',
                style: TextStyle(
                    fontSize: 16.0
                ),
                textAlign: TextAlign.left,
              ),

            ],
          ),
        ),
      ),
    );
  }
}


