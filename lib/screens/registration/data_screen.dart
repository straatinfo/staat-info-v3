import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:straatinfoflutter/providers/data.dart';
import 'package:straatinfoflutter/backend/services/auth_service.dart';
import 'package:straatinfoflutter/backend/services/postal_code_service.dart';
import 'package:straatinfoflutter/components/dialogs.dart';
import 'package:straatinfoflutter/utils/constants.dart';
import 'package:straatinfoflutter/components/rounded_button.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:straatinfoflutter/screens/registration/terms_screen.dart';
import 'package:straatinfoflutter/backend/model/data_registration.dart';
import 'package:random_string/random_string.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:straatinfoflutter/components/loading_dialog.dart';
import 'package:straatinfoflutter/backend/model/postal_code_address.dart';

class DataScreen extends StatefulWidget {
  final TabController tabController;
  DataScreen({this.tabController});
  @override
  _DataScreenState createState() => _DataScreenState();
}
class _DataScreenState extends State<DataScreen> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  PostalCodeService _postalCodeService = PostalCodeService();
  AuthService _authService = AuthService();
  bool _showSpinner = false;
  String postalCode;
  String houseNumber;
  DataRegistration dataFormValue;
  String usernameSuffix;
  String user;
  String completeUsername;
  bool userNameStatus;
  String emailAddress;
  bool emailAddressStatus;
  DataRegistration dataScreenForm;
  bool isTermClicked;
  PostalCodeAddress addressPostalCode;
  PostalCodeAddress providerPostalCodeAddressValue;

  @override
  void initState() {
    super.initState();
    _initializeDataScreenFormValues();
  }

  _initializeDataScreenFormValues() {
    usernameSuffix = randomAlphaNumeric(5);
    dataScreenForm = Provider.of<Data>(context, listen: false).registrationData;
    completeUsername = Provider.of<Data>(context, listen: false).registrationCompleteUsername;
    if(dataScreenForm != null) {
      var existingUser = dataScreenForm.username;
      var separatedUser = existingUser.split(':');
      user = separatedUser[0];
      usernameSuffix = separatedUser[1];
    }
  }

  _toggleSpinner(bool val) {
    if(mounted) {
      setState(() => _showSpinner = val);
    }
  }

  _getAddress(dynamic result) {
    addressPostalCode = PostalCodeAddress(
        streetName: result['_embedded']['addresses'][0]['street'],
        town: result['_embedded']['addresses'][0]['municipality']['label'],
        hostId: result['_host']['_id']
    );
    Provider.of<Data>(context, listen: false).updatePostalCodeAddress(addressPostalCode);
  }
  _clearAddress() {
    Provider.of<Data>(context, listen: false).updatePostalCodeAddress(null);
  }

  @override
  Widget build(BuildContext context) {
    isTermClicked = Provider.of<Data>(context).registrationTerm;
    userNameStatus = Provider.of<Data>(context).registrationIsUserNameValid;
    emailAddressStatus = Provider.of<Data>(context).registrationIsEmailValid;
    providerPostalCodeAddressValue = Provider.of<Data>(context).registrationPostalCodeAddress;
    print('Data Screen rebuilding');
    print('Username Status:  $userNameStatus || EmailAdd Status:  $emailAddressStatus');
    print('Postal code address $providerPostalCodeAddressValue');
    return ModalProgressHUD(
      inAsyncCall: _showSpinner,
      progressIndicator: LoadingDialog(title: 'Validating input...',),
      child: SingleChildScrollView(
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                child: FormBuilder(
                  key: _fbKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[

                      Text('Gender',
                        textAlign: TextAlign.left,
                        style: kLabelInInputFieldDecoration,
                      ),
                      SizedBox(height: 3.0,),
                      FormBuilderRadio(
                        initialValue: dataScreenForm == null ? null : dataScreenForm.gender,
                        attribute: 'gender',
                        decoration: kTextFieldDecoration,
                        options: [
                          'Male',
                          'Female'
                        ]
                            .map((g) => FormBuilderFieldOption(value: g,))
                            .toList(growable: false),
                        validators: [
                          FormBuilderValidators.required(errorText: 'Gender field is required'),
                        ],
                      ),

                      SizedBox(height: 8.0,),
                      Text('Firstname',
                        textAlign: TextAlign.left,
                        style: kLabelInInputFieldDecoration,
                      ),
                      SizedBox(height: 3.0,),
                      FormBuilderTextField(
                        initialValue: dataScreenForm == null ? null : dataScreenForm.fname,
                        autofocus: false,
                        attribute: 'fname',
                        decoration: kTextFieldDecoration.copyWith(hintText: 'Enter Firstname'),
                        validators: [
                          FormBuilderValidators.required(errorText: 'Firstname is required')
                        ],
                      ),

                      SizedBox(height: 8.0,),
                      Text('Lastname',
                        textAlign: TextAlign.left,
                        style: kLabelInInputFieldDecoration,
                      ),
                      SizedBox(height: 3.0,),
                      FormBuilderTextField(
                        initialValue: dataScreenForm == null ? null : dataScreenForm.lname,
                        attribute: 'lname',
                        decoration: kTextFieldDecoration.copyWith(hintText: 'Enter Lastname'),
                        validators: [
                          FormBuilderValidators.required(errorText: 'Lastname is required')
                        ],
                      ),

                      SizedBox(height: 8.0,),
                      Text('Username',
                        textAlign: TextAlign.left,
                        style: kLabelInInputFieldDecoration,
                      ),
                      SizedBox(height: 3.0,),

                      Row(
                        children: <Widget>[
                          Flexible(
                            child: Focus(
                              child: FormBuilderTextField(
                                initialValue: dataScreenForm == null ? null : user,
                                attribute: 'username',
                                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter Username'),
                                validators: [
                                  FormBuilderValidators.required(errorText: 'Username is required')
                                ],
                                onChanged: (val) {
                                  user = val;
                                },
                              ),
                              onFocusChange: (hasFocus) async {
                                if(!hasFocus) {
                                  if(user.isNotEmpty && user != null) {
                                    _toggleSpinner(true);
                                    completeUsername = user+':'+usernameSuffix;
                                    Provider.of<Data>(context, listen: false).updateCompleteUsername(completeUsername);
                                    var result = await _authService.validateInput(completeUsername, 'username');
                                    _toggleSpinner(false);
                                      if(result) {
                                        Provider.of<Data>(context, listen: false).updateUserNameStatus(true);
                                      } else {
                                        Provider.of<Data>(context, listen: false).updateUserNameStatus(false);
                                        await Dialogs.alert(context, 'Error', 'Username is already taken');
                                      }
                                  }
                                }
                              },
                            ),
                          ),
                          SizedBox(width: 3.0,),
                          Text('_ID: $usernameSuffix', style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),),
                        ],
                      ),


                      SizedBox(height: 8.0,),
                      Text('Postal Code',
                        textAlign: TextAlign.left,
                        style: kLabelInInputFieldDecoration,
                      ),
                      SizedBox(height: 3.0,),
                      Focus(
                        child: FormBuilderTextField(
                          initialValue: dataScreenForm == null ? null : dataScreenForm.postalCode,
                          attribute: 'postalCode',
                          decoration: kTextFieldDecoration.copyWith(hintText: 'Enter Postal Code'),
                          validators: [
                            FormBuilderValidators.required(errorText: 'Postal Code is required')
                          ],
                          onChanged: (value) {
                            postalCode = value;
                          },
                        ),
                        onFocusChange: (hasFocus) async {
                          if(!hasFocus) {
                            if((postalCode != null && postalCode != '') && (houseNumber != null && houseNumber != '')) {
                              _toggleSpinner(true);
                              var result = await _postalCodeService.verifyPostCode(postalCode, houseNumber);
                              _toggleSpinner(false);
                              if(result == 400) {
                                _clearAddress();
                                await Dialogs.alert(context, 'Error', 'The postal code seems to be incorrect. Please fill in the correct postal code.');
                              }
                              else {
                                _getAddress(result);
                              }
                            }
                          } else {
//                            _clearAddress();
                          }
                        },
                      ),

                      SizedBox(height: 8.0,),
                      Text('House Number',
                        textAlign: TextAlign.left,
                        style: kLabelInInputFieldDecoration,
                      ),
                      SizedBox(height: 3.0,),
                      Focus(
                        child: FormBuilderTextField(
                          initialValue: dataScreenForm == null ? null : dataScreenForm.houseNumber,
                          attribute: 'houseNumber',
                          decoration: kTextFieldDecoration.copyWith(hintText: 'Enter House Number'),
                          validators: [
                            FormBuilderValidators.required(errorText: 'House Number is required')
                          ],
                          onChanged: (value) {
                            houseNumber = value;
                          },
                        ),
                        onFocusChange: (hasFocus) async {
                          if(!hasFocus) {
                            if((postalCode != null && postalCode != '') && (houseNumber != null && houseNumber != '')) {
                              _toggleSpinner(true);
                              var result = await _postalCodeService.verifyPostCode(postalCode, houseNumber);
                              _toggleSpinner(false);
                              if(result == 400) {
                                _clearAddress();
                                await Dialogs.alert(context, 'Error', 'The house number entry seems to be incorrect. Please fill in the correct house number');
                              }
                              else {
                                _getAddress(result);
                              }
                            }
                          } else {
//                            _clearAddress();
                          }
                        },
                      ),
                      SizedBox(height: 8.0,),
                      Text('Street (Autofill)',
                        textAlign: TextAlign.left,
                        style: kLabelInInputFieldDecoration,
                      ),

                      SizedBox(height: 3.0,),
                      Container(
                        height: 42.0,
                        decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(10.0)),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Consumer<Data>(
                              builder: (_, data, __) => data.registrationPostalCodeAddress == null ?
                              Text(' ', style: TextStyle(fontSize: 18.0),) :
                              Text(' ${data.registrationPostalCodeAddress.streetName}', style: TextStyle(fontSize: 18.0),)
                            ),
                        ),
                      ),



                      SizedBox(height: 8.0,),
                      Text('Town (Autofill)',
                        textAlign: TextAlign.left,
                        style: kLabelInInputFieldDecoration,
                      ),

                      SizedBox(height: 3.0,),
                      Container(
                        height: 42.0,
                        decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(10.0)),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Consumer<Data>(
                              builder: (_, data, __) => data.registrationPostalCodeAddress == null ?
                              Text(' ', style: TextStyle(fontSize: 18.0),) :
                              Text(' ${data.registrationPostalCodeAddress.town}', style: TextStyle(fontSize: 18.0),)
                          ),
                      ),),

                      SizedBox(height: 8.0,),
                      Text('Email Address',
                        textAlign: TextAlign.left,
                        style: kLabelInInputFieldDecoration,
                      ),
                      SizedBox(height: 3.0,),

                      Focus(
                        child: FormBuilderTextField(
                          initialValue: dataScreenForm == null ? null : dataScreenForm.email,
                          attribute: 'email',
                          keyboardType: TextInputType.emailAddress,
                          decoration: kTextFieldDecoration.copyWith(hintText: 'Enter Email Address'),
                          validators: [
                            FormBuilderValidators.required(errorText: 'Email Address is required'),
                            FormBuilderValidators.email(errorText: 'Enter a valid email address')
                          ],
                          onChanged: (val) {
                            emailAddress = val;
                          },
                        ),
                        onFocusChange: (hasFocus) async {
                          if(!hasFocus) {
                            if(emailAddress.isNotEmpty && user != null) {
                              _toggleSpinner(true);
                              var result = await _authService.validateInput(emailAddress, 'email');
                              _toggleSpinner(false);
                              if(result) {
                                Provider.of<Data>(context, listen: false).updateEmailStatus(true);
                              } else {
                                Provider.of<Data>(context, listen: false).updateEmailStatus(false);
                                await Dialogs.alert(context, 'Error', 'Email Address is already taken');
                              }
                            }
                          }
                        },
                      ),



                      SizedBox(height: 8.0,),
                      Text('Mobile Number',
                        textAlign: TextAlign.left,
                        style: kLabelInInputFieldDecoration,
                      ),
                      SizedBox(height: 3.0,),
                      FormBuilderTextField(
                        initialValue: dataScreenForm == null ? null : dataScreenForm.phoneNumber,
                        attribute: 'phoneNumber',
                        keyboardType: TextInputType.numberWithOptions(),
                        decoration: kTextFieldDecoration.copyWith(hintText: 'Enter Mobile Number'),
                        validators: [
                          FormBuilderValidators.required(errorText: 'Mobile Number is required'),
                          FormBuilderValidators.numeric(errorText: 'Enter a valid number'),
                          FormBuilderValidators.pattern('^(?:(?:\\(?(?:0(?:0|11)\\)?[\\s-]?\\(?|\\+)44\\)?[\\s-]?(?:\\(?0\\)?[\\s-]?)?)|(?:\\(?0))(?:(?:\\d{5}\\)?[\\s-]?\\d{4,5})|(?:\\d{4}\\)?[\\s-]?(?:\\d{5}|\\d{3}[\\s-]?\\d{3}))|(?:\\d{3}\\)?[\\s-]?\\d{3}[\\s-]?\\d{3,4})|(?:\\d{2}\\)?[\\s-]?\\d{4}[\\s-]?\\d{4}))(?:[\\s-]?(?:x|ext\\.?|\\#)\\d{3,4})?\$',
                              errorText: 'Please check the mobile number format'),
                        ],
                      ),

                      SizedBox(height: 8.0,),
                      Text('Password',
                        textAlign: TextAlign.left,
                        style: kLabelInInputFieldDecoration,
                      ),
                      SizedBox(height: 3.0,),
                      FormBuilderTextField(
                        initialValue: dataScreenForm == null ? null : dataScreenForm.password,
                        maxLines: 1,
                        obscureText: true,
                        attribute: 'password',
                        decoration: kTextFieldDecoration.copyWith(hintText: 'Enter Password'),
                        validators: [
                          FormBuilderValidators.required(errorText: 'Password required'),
                          FormBuilderValidators.minLength(6, errorText: 'Password must be atleast 6 characters'),
                          FormBuilderValidators.pattern('^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d@\$!%*#?&]{8,}\$', errorText: 'Must be atleast 8 alphanumeric characters'),
                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Checkbox(value: isTermClicked, onChanged: null),
                          RoundedButton(title: 'TERMS AND CONDITION', color: Colors.blue, onPressed: () {
                            FocusScopeNode currentFocus = FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }
                            Navigator.pushNamed(context, TermsScreen.id);
                          }
                          ),
                        ],
                      ),

                      RoundedButton(title: 'NEXT STEP', color: Color(0xFF7dbf40), onPressed: () async {
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                        if(_fbKey.currentState.saveAndValidate()) {
                          print(_fbKey.currentState.value['gender']);
                          if(providerPostalCodeAddressValue == null) {
                            await Dialogs.alert(context, 'Error', 'The postal code and/or house number entry seems to be incorrect. Please fill in the correct postal code and house number');
                          } else {

                            if(userNameStatus && emailAddressStatus) {
                              if(isTermClicked) {
                                dataFormValue = DataRegistration(
                                  gender: _fbKey.currentState.value['gender'],
                                  fname: _fbKey.currentState.value['fname'],
                                  lname: _fbKey.currentState.value['lname'],
                                  username: completeUsername,
                                  postalCode: _fbKey.currentState.value['postalCode'],
                                  houseNumber: _fbKey.currentState.value['houseNumber'],
                                  streetName: providerPostalCodeAddressValue.streetName,
                                  hostId: providerPostalCodeAddressValue.hostId,
                                  town: providerPostalCodeAddressValue.town,
                                  email: _fbKey.currentState.value['email'],
                                  phoneNumber: _fbKey.currentState.value['phoneNumber'],
                                  password: _fbKey.currentState.value['password'],
                                  state: providerPostalCodeAddressValue.town,
                                );
                                Provider.of<Data>(context, listen: false).fillUpRegistrationData(dataFormValue);
                                if(!_showSpinner) {
                                  widget.tabController.animateTo(1);
                                }

                              } else {
                                await Dialogs.alert(context, 'Error', 'You did not accept the terms and condition.');
                              }
                            } else if(!userNameStatus) {
                              await Dialogs.alert(context, 'Error', 'Username is already taken');
                            } else {
                              await Dialogs.alert(context, 'Error', 'Email is already taken');
                            }
                          }
                        } else {
                          await Dialogs.alert(context, 'Error', 'Please check all the fields');
                        }
                      }),

                      SizedBox(height: 10.0,),


                      Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text('Existing User?', style: kLabelInInputFieldDecoration,),),
                        ],
                      ),
                      SizedBox(height: 10.0,),

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


