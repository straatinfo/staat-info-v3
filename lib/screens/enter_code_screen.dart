import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EnterCodeScreen extends StatefulWidget {
  static const String id = 'enter_code_screen';
  @override
  _EnterCodeScreenState createState() => _EnterCodeScreenState();
}

class _EnterCodeScreenState extends State<EnterCodeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Straat.Info'),
        backgroundColor: Color(0xff4c6883),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          Text('Enter Code'),
//          TextField(
//            onChanged: (value) {
//
//            },
//            decoration: InputDecoration(
//              hintText: 'Enter Code',
//              contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
//              border: OutlineInputBorder(
//                borderRadius: BorderRadius.all(Radius.circular(32.0)),
//              ),
//              enabledBorder: OutlineInputBorder(
//                borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
//                borderRadius: BorderRadius.all(Radius.circular(32.0)),
//              ),
//              focusedBorder: OutlineInputBorder(
//                borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
//                borderRadius: BorderRadius.all(Radius.circular(32.0)),
//              ),
//            ),
//          ),
//          SizedBox(
//            height: 10.0,
//          ),
//          TextField(
//            onChanged: (value) {
//
//            },
//            decoration: InputDecoration(
//              hintText: 'Enter Code',
//              contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
//              border: OutlineInputBorder(
//                borderRadius: BorderRadius.all(Radius.circular(32.0)),
//              ),
//            ),
//          ),
        ],
      ),
    );
  }
}
