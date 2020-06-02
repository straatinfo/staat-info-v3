import 'package:flutter/material.dart';
import 'package:straatinfoflutter/constants.dart';
import 'package:straatinfoflutter/components/rounded_button.dart';
import 'package:straatinfoflutter/screens/terms_and_condition_screen.dart';



class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String selectedRadioTile;
  String fname;
  String lname;
  String username;
  int postalCode;
  String houseNumber;
  String streetName;
  String email;
  String phoneNumber;
  String password;

  @override
  void initState() {
    super.initState();
    selectedRadioTile = '';
  }
  setSelectedRadioTile(String val) {
    setState(() {
      selectedRadioTile = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'images/straat_info_icon.png',
          width: 50.0,
          height: 50.0,
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text('Gender ',
                textAlign: TextAlign.left,
                style: kLabelInInputFieldDecoration,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: RadioListTile(value: 'M', groupValue: selectedRadioTile, title: Text('Male'), activeColor: Color(0xff4c6883), onChanged: (val) {
                        print('$val');
                        setSelectedRadioTile(val);
                      }),
                  ),
                  Expanded(
                      child: RadioListTile(value: 'F', groupValue: selectedRadioTile, title: Text('Female'), activeColor: Color(0xff4c6883), onChanged: (val) {
                        print('$val');
                        setSelectedRadioTile(val);
                      }),
                  ),
                ],
              ),

              SizedBox(height: 8.0,),
              Text('Firstname ',
                textAlign: TextAlign.left,
                style: kLabelInInputFieldDecoration,
              ),
              SizedBox(height: 3.0,),
              TextField(
                onChanged: (value) {

                },
//                autofocus: true,
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter Firstname'),
              ),

              SizedBox(height: 8.0,),
              Text('Lastname',
                textAlign: TextAlign.left,
                style: kLabelInInputFieldDecoration,
              ),
              SizedBox(height: 3.0,),
              TextField(
                onChanged: (value) {

                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter Lastname'),
              ),

              SizedBox(height: 8.0,),
              Text('Username',
                textAlign: TextAlign.left,
                style: kLabelInInputFieldDecoration,
              ),
              SizedBox(height: 3.0,),
              TextField(
                onChanged: (value) {

                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter Username'),
              ),

              SizedBox(height: 8.0,),
              Text('Postal Code',
                textAlign: TextAlign.left,
                style: kLabelInInputFieldDecoration,
              ),
              SizedBox(height: 3.0,),
              TextField(
                onChanged: (value) {

                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter Postal Code'),
              ),

              SizedBox(height: 8.0,),
              Text('House Number',
                textAlign: TextAlign.left,
                style: kLabelInInputFieldDecoration,
              ),
              SizedBox(height: 3.0,),
              TextField(
                onChanged: (value) {

                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter House Number'),
              ),

              SizedBox(height: 8.0,),
              Text('Street',
                textAlign: TextAlign.left,
                style: kLabelInInputFieldDecoration,
              ),
              SizedBox(height: 3.0,),
              TextField(
                onChanged: (value) {

                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Street'),
              ),

              SizedBox(height: 8.0,),
              Text('Town',
                textAlign: TextAlign.left,
                style: kLabelInInputFieldDecoration,
              ),
              SizedBox(height: 3.0,),
              TextField(
                onChanged: (value) {

                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Town'),
              ),

              SizedBox(height: 8.0,),
              Text('Email Address',
                textAlign: TextAlign.left,
                style: kLabelInInputFieldDecoration,
              ),
              SizedBox(height: 3.0,),
              TextField(
                onChanged: (value) {

                },
                keyboardType: TextInputType.emailAddress,
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter Email Address'),
              ),

              SizedBox(height: 8.0,),
              Text('Mobile Number',
                textAlign: TextAlign.left,
                style: kLabelInInputFieldDecoration,
              ),
              SizedBox(height: 3.0,),
              TextField(
                onChanged: (value) {

                },
                keyboardType: TextInputType.numberWithOptions(),
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter Mobile Number'),
              ),

              SizedBox(height: 8.0,),
              Text('Password',
                textAlign: TextAlign.left,
                style: kLabelInInputFieldDecoration,
              ),
              SizedBox(height: 3.0,),
              TextField(
                onChanged: (value) {

                },
                obscureText: true,
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter Password'),
              ),

              RoundedButton(title: 'TERMS AND CONDITION', color: Colors.blue, onPressed: () {
                showModalBottomSheet(context: context, isScrollControlled: true, builder: (context) => TermsAndConditionScreen());
              }),
              RoundedButton(title: 'NEXT STEP', color: Colors.green, onPressed: null,),
              Container(
                child: Row(
                  children: <Widget>[
                    FlatButton(
                        onPressed: () {
//                          Navigator.pop(context);
                        },
                        child: Text('Existing User ?')
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),

    );
  }
}
