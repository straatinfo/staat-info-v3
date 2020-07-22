import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:straatinfoflutter/backend/services/auth_service.dart';
import 'package:straatinfoflutter/utils/constants.dart';
import 'package:straatinfoflutter/components/rounded_button.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:straatinfoflutter/components/loading_dialog.dart';
import 'package:straatinfoflutter/screens/landing_page/home_screen.dart';
import 'package:straatinfoflutter/screens/registration/registration_tab_screen.dart';
import 'package:straatinfoflutter/components/dialogs.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  AuthService _authService = AuthService();
  bool _showSpinner = false;
  bool _resultLogin = false;

  _toggleSpinner(bool val) {
    if(mounted) {
      setState(() => _showSpinner = val);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Straat.Info'),
        backgroundColor: Color(0xff4c6883),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _showSpinner,
        progressIndicator: LoadingDialog(title: 'Validating...',),
        child: Center(
          child: SingleChildScrollView(
            child: GestureDetector(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FormBuilder(
                  key: _fbKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Image.asset('images/straat_info_icon.png', width: 200.0, height: 200.0,),
                      SizedBox(height: 8.0,),
                      Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(context, RegistrationTabScreen.id),
                            child: Text('New User ? Click here', style: kLabelInInputFieldDecoration,),),
                        ],
                      ),
                      SizedBox(height: 10.0,),
                      Text('Existing User? Log in:', style: kLabelInInputFieldDecoration,),

                      SizedBox(height: 10.0,),
                      FormBuilderTextField(
                        attribute: 'email',
                        decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
                        validators: [
                          FormBuilderValidators.required(errorText: 'Email Address is required'),
                          FormBuilderValidators.email(errorText: 'Enter a valid email address')
                        ],
                      ),

                      SizedBox(height: 10.0,),

                      FormBuilderTextField(
                        maxLines: 1,
                        obscureText: true,
                        attribute: 'password',
                        decoration: kTextFieldDecoration.copyWith(hintText: 'Enter Password'),
                        validators: [
                          FormBuilderValidators.required(errorText: 'Password required'),
                        ],
                      ),

                      RoundedButton(title: 'LOGIN', color: Color(0xFF7dbf40), onPressed: () async {
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }

                        if(_fbKey.currentState.saveAndValidate()) {
                          _toggleSpinner(true);
                          _resultLogin = await _authService.signin(_fbKey.currentState.value['email'], _fbKey.currentState.value['password']);
                          _toggleSpinner(false);
                          print(_resultLogin);
                          if(_resultLogin != false) {
                            Navigator.of(context).pushNamedAndRemoveUntil(HomeScreen.id, (Route<dynamic> route) => false);
                          } else {
                            await Dialogs.alert(context, 'Error', 'Invalid Account!');
                          }
                        } else {
                          await Dialogs.alert(context, 'Error', 'Please check all the fields');
                        }
                      }),

                      SizedBox(height: 10.0,),
                      Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () => print('Redirect to forgot password'),
                            child: Text('Forgot Password?', style: kLabelInInputFieldDecoration,),),
                        ],
                      ),


                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
