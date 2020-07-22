import 'package:flutter/material.dart';
import 'package:straatinfoflutter/backend/services/auth_service.dart';
import 'package:straatinfoflutter/utils/constants.dart';
import 'package:straatinfoflutter/components/rounded_button.dart';
import 'package:straatinfoflutter/screens/login/login_screen.dart';
import 'package:straatinfoflutter/components/dialogs.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:straatinfoflutter/components/loading_dialog.dart';


class EnterCodeScreen extends StatefulWidget {
  static const String id = 'enter_code_screen';
  @override
  _EnterCodeScreenState createState() => _EnterCodeScreenState();
}

class _EnterCodeScreenState extends State<EnterCodeScreen> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _enteredCode = '';
  AuthService _authService = AuthService();
  bool _showSpinner = false;
  bool _resultOfCodeValidation = false;

  _toggleSpinner(bool val) {
    if(mounted) {
      setState(() => _showSpinner = val);
    }
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
        progressIndicator: LoadingDialog(title: 'Validating Code...',),
        child: Center(
            child: SingleChildScrollView(
              child: GestureDetector(
                onTap: () {
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                },
                child: Container(
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Image.asset('images/straat_info_icon.png', width: 200.0, height: 200.0,),
                          SizedBox(height: 8.0,),
                          Text('Enter Code',
                            textAlign: TextAlign.center,
                            style: kLabelInInputFieldDecoration,
                          ),
                          SizedBox(height: 8.0,),
                          TextFormField(
                            controller: _controller,
                            obscureText: true,
                            textAlign: TextAlign.center,
                            decoration: kTextFieldDecoration.copyWith(hintText: 'Enter Code'),
                            validator: (codeValue) {
                              if(codeValue.isEmpty) {
                                return 'Please enter code';
                              }
                              return null;
                            },
                            onChanged: (value) => _enteredCode = value,

                          ),
                          SizedBox(width: 8.0,),
                          RoundedButton(title: 'OK', color: Colors.blue, onPressed: () async {
                            FocusScopeNode currentFocus = FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }
                            if(_formKey.currentState.validate()) {
                              _toggleSpinner(true);
                              _resultOfCodeValidation =  await _authService.verifyCode(_enteredCode);
                              _toggleSpinner(false);
                              if(_resultOfCodeValidation) {
                                Navigator.of(context).pushNamedAndRemoveUntil(LoginScreen.id, (Route<dynamic> route) => false);
                              } else {
                                await Dialogs.alert(context, 'Error', 'Invalid Code');
                              }
                              _controller.clear();
                            }
                          },
                          ),
                          RoundedButton(title: 'CANCEL', color: Colors.red, onPressed: () {},),
                          Text(
                            'We\'re still testing and that feedback is welcome. \n This way I hope to prevent more negative feedback online',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14.0),
                          ),
                        ],
                      ),
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

