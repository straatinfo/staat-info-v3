import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  final String title;
  LoadingDialog({this.title});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          SizedBox(width: 10.0,),
          Text(title),
        ],
      ),
    );
  }
}
