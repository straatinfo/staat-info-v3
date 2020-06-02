import 'package:flutter/material.dart';
import 'package:straatinfoflutter/constants.dart';
import 'package:straatinfoflutter/components/rounded_button.dart';
import 'package:straatinfoflutter/screens/registration_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Straat.Info'),
        backgroundColor: Color(0xff4c6883),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Image.asset(
                'images/straat_info_icon.png',
                width: 100.0,
                height: 100.0,
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    Text('New User? ',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.pushNamed(context, RegistrationScreen.id);
                      },
                      child: Text('Click here')
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.0,),
              Text('Existing user? Log in:',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              SizedBox(height: 8.0,),
              TextField(
                onChanged: (value) {},
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
              ),
              SizedBox(height: 8.0,),
              TextField(
                onChanged: (value) {},
                obscureText: true,
                textAlign: TextAlign.center,
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your password'),
              ),
              RoundedButton(title: 'LOGIN', color: Colors.blue, onPressed: () {

              },),
              Text('Forgot Password',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
