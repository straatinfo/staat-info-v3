import 'package:flutter/material.dart';
import 'package:straatinfoflutter/components/rounded_button.dart';

class TermsAndConditionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('TERMS AND CONDITION',
                style: TextStyle(fontWeight: FontWeight.bold),),
              Text('Call 911 '),
              Text('Lorem Ipsum is simply dummy text of the printing and typesetting industry. '
                  'Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, '
                  'when an unknown printer took a galley of type and scrambled it to make a type specimen book. '
                  'It has survived not only five centuries, but also the leap into electronic typesetting, '
                  'remaining essentially unchanged. It was popularised in the 1960s with the release of'
                  ' Letraset sheets containing Lorem Ipsum passages, and more recently with'
                  'desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.'),
              Text('Lorem Ipsum is simply dummy text of the printing and typesetting industry. '
                  'Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, '
                  'when an unknown printer took a galley of type and scrambled it to make a type specimen book. '
                  'It has survived not only five centuries, but also the leap into electronic typesetting, '
                  'remaining essentially unchanged. It was popularised in the 1960s with the release of'
                  ' Letraset sheets containing Lorem Ipsum passages, and more recently with'
                  'desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.'),
              Text('Lorem Ipsum is simply dummy text of the printing and typesetting industry. '
                  'Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, '
                  'when an unknown printer took a galley of type and scrambled it to make a type specimen book. '
                  'It has survived not only five centuries, but also the leap into electronic typesetting, '
                  'remaining essentially unchanged. It was popularised in the 1960s with the release of'
                  ' Letraset sheets containing Lorem Ipsum passages, and more recently with'
                  'desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.'),
              RoundedButton(title: 'I HEREBY ACCEPT THE GENERAL TERMS', color: Colors.green, onPressed: () {
                  Navigator.pop(context);
              }),

              RoundedButton(title: 'CANCEL', color: Colors.red, onPressed: () {
                Navigator.pop(context);
              }),
            ],
          ),
      ),
    );
  }
}
