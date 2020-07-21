import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:straatinfoflutter/providers/data.dart';
import 'package:straatinfoflutter/components/rounded_button.dart';

class TermsScreen extends StatefulWidget {
  static const String id = 'terms_screen';
  @override
  _TermsScreenState createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {

  Future<bool> _onBackPresed() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Warning'),
          content: Text('Are you sure you want to quit without accepting the terms and condition?'),
          actions: <Widget>[
            FlatButton(
              child: Text('No'),
              onPressed: () => Navigator.of(context).pop(),),
            FlatButton(
              child: Text('Yes'),
              onPressed: () {
                Provider.of<Data>(context, listen: false).fillTerms(false);
                Navigator.pop(context);
                Navigator.pop(context);
              },),
          ],
        );
      });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Center(child: Text('Terms And Condition', style: TextStyle(color: Colors.black),)),
          backgroundColor: Colors.white,
        ),
        body: WillPopScope(
          onWillPop: _onBackPresed,
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    Text('Always call 911 ', style: TextStyle(fontSize: 20.0),),
                    Text('Lorem Ipsum is simply dummy text of the printing and typesetting industry. '
                        'Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, '
                        'when an unknown printer took a galley of type and scrambled it to make a type specimen book. '
                        'It has survived not only five centuries, but also the leap into electronic typesetting, '
                        'remaining essentially unchanged. It was popularised in the 1960s with the release of'
                        ' Letraset sheets containing Lorem Ipsum passages, and more recently with'
                        'desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.',
                      style: TextStyle(fontSize: 20.0),),
                    RoundedButton(title: 'I HEREBY ACCEPT THE GENERAL TERMS', color: Colors.green, onPressed: () {
                      Provider.of<Data>(context, listen: false).fillTerms(true);
                      Navigator.pop(context);
                    },),
                    RoundedButton(title: 'CANCEL', color: Colors.red, onPressed: () {
                      Provider.of<Data>(context, listen: false).fillTerms(false);
                      Navigator.pop(context);
                    },),
                  ],
                ),
              ),
            ),
          ),
        ),
    );
  }
}
