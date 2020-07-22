import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:straatinfoflutter/backend/services/team_service.dart';
import 'package:straatinfoflutter/backend/services/auth_service.dart';
import 'package:straatinfoflutter/components/rounded_button.dart';
import 'package:straatinfoflutter/backend/model/team.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:straatinfoflutter/providers/data.dart';
import 'package:straatinfoflutter/components/dialogs.dart';
import 'package:straatinfoflutter/backend/model/data_registration.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:straatinfoflutter/components/loading_dialog.dart';
import 'package:straatinfoflutter/backend/model/postal_code_address.dart';
import 'package:straatinfoflutter/screens/landing_page/home_screen.dart';




class TeamScreen extends StatefulWidget {
  @override
  _TeamScreenState createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  String selectedRadioTile;
  Team selectedTeam;
  bool showDropdownTeam = false;
  bool _isLoading = false;
  bool reporterScreenForm;
  bool _showSpinner = false;
  PostalCodeAddress providerPostalCodeAddressValue;
  bool isTermClicked;
  bool userNameStatus;
  bool emailAddressStatus;


  List<Team> teamResult = [];
  DataRegistration dataScreenForm;
  TeamService _teamService = TeamService();
  AuthService _authService = AuthService();
  List<Team> teams = [];

  _setSelectedRadioTile(String val) {
    if(mounted) {
      setState(() => selectedRadioTile = val);
    }
  }
  _toggleLoading(bool val) {
    if(mounted) {
      setState(() => _isLoading = val);
    }
  }
  _toggleSpinner(bool val) {
    if(mounted) {
      setState(() => _showSpinner = val);
    }
  }

  @override
  Widget build(BuildContext context) {
    dataScreenForm = Provider.of<Data>(context).registrationData;
    reporterScreenForm = Provider.of<Data>(context).registrationReportValue;
    providerPostalCodeAddressValue = Provider.of<Data>(context).registrationPostalCodeAddress;
    userNameStatus = Provider.of<Data>(context).registrationIsUserNameValid;
    emailAddressStatus = Provider.of<Data>(context).registrationIsEmailValid;
    isTermClicked = Provider.of<Data>(context).registrationTerm;


    print('TeamData from Team Screen, Provider ReporterForm Value: $reporterScreenForm');
    print('Data from Team Screen, Provider DataFrom Value: $dataScreenForm');
    print('Username Status:  $userNameStatus || EmailAdd Status:  $emailAddressStatus');
    print('Postal code address $providerPostalCodeAddressValue');
    return ModalProgressHUD(
      inAsyncCall: _showSpinner,
      progressIndicator: LoadingDialog(title: 'Validating...',),
      child: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[

                    Text('Make choice of the three below:',
                      style: TextStyle(fontSize: 20.0),
                      textAlign: TextAlign.left,
                    ),

                    RadioListTile(
                        value: 'alone',
                        groupValue: selectedRadioTile,
                        title: Text('I am individual reporter'),
                        activeColor: Color(0xff4c6883),
                        onChanged: null,
                        ),

                    RadioListTile(
                        value: 'joinTeam',
                        groupValue: selectedRadioTile,
                        title: Text('I want to join an existing team'),
                        activeColor: Color(0xff4c6883),
                        onChanged: (val) async {
                          _toggleLoading(true);
                          _setSelectedRadioTile(val);
                          teamResult = await _teamService.getTeams(reporterScreenForm);
                          if(teamResult.length > 0) {
                            for(Team team in teamResult) {
                              teams.add(Team(name: team.name, id: team.id));
                            }
                          }
                          showDropdownTeam = true;
                          _toggleLoading(false);
                        }),

//                RadioListTile(
//                    value: 'createTeam',
//                    groupValue: selectedRadioTile,
//                    title: Text('I want to start a new team'),
//                    activeColor: Color(0xff4c6883),
//                    onChanged: isLoading ? null : (val) {
//                      showDropdownTeam = false;
//                      _setSelectedRadioTile(val);
//                    }),


                    _isLoading ?  SpinKitThreeBounce(color: Colors.green, size: 40.0,) :
                    Container(
                      height: 60.0,
                      child: InputDecorator(
                        decoration: const InputDecoration(border: const OutlineInputBorder()),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            isExpanded: true,
                            hint: Text('Choose Team'),
                            value: selectedTeam,
                            items: teams.map((Team team) {
                              return DropdownMenuItem<Team>(
                                  value: team,
                                  child: Text(team.name));
                            }).toList(),
                            onChanged: (Team value) {
                              if(mounted) {
                                setState(() => selectedTeam = value );
                              }
                            },
                          ),
                        ),
                      ),
                    ),

                    RoundedButton(title: 'REGISTER', color: Color(0xFF7dbf40), onPressed: _isLoading ? null : () async {
                      if(providerPostalCodeAddressValue == null) {
                        await Dialogs.alert(context, 'Error', 'The postal code and/or house number entry seems to be incorrect. Please fill in the correct postal code and house number');
                      } else {
                        if(userNameStatus && emailAddressStatus) {
                          if(isTermClicked) {

                            if(selectedRadioTile == null) {
                              await Dialogs.alert(context, 'Error', 'Please make  a choice of the three below');
                            } else if(selectedRadioTile == 'createTeam') {
                              await Dialogs.alert(context, 'Team Creation', 'Let Create a team');
                            } else {

                              if(selectedTeam == null) {
                                await Dialogs.alert(context, 'Error', 'Please select a team');
                              } else {
                              _toggleSpinner(true);
                              var result = await _authService.signUp(dataScreenForm, reporterScreenForm, selectedTeam.id);
                              _toggleSpinner(false);
                              print(result);
                              if(result['httpCode'] >= 200 && result['httpCode'] < 400) {
                                var jwt = result['token'];
                                print(jwt);
                                Provider.of<Data>(context, listen: false).resetRegistrationForm();
//                                Navigator.pushNamed(context, HomeScreen.id);
                                Navigator.of(context).pushNamedAndRemoveUntil(HomeScreen.id, (Route<dynamic> route) => false);
                              } else {
                                await Dialogs.alert(context, 'Error', '${result['message']}');
                              }

//
//                                print(reporterScreenForm);
//                                print(selectedTeam.id);
//                                print('--------');
//                                print(dataScreenForm.gender);
//                                print(dataScreenForm.fname);
//                                print(dataScreenForm.lname);
//                                print(dataScreenForm.username);
//                                print(dataScreenForm.postalCode);
//                                print(dataScreenForm.houseNumber);
//                                print(dataScreenForm.streetName);
//                                print(dataScreenForm.email);
//                                print(dataScreenForm.phoneNumber);
//                                print(dataScreenForm.password);
//                                print(dataScreenForm.town);
//                                print(dataScreenForm.state);
//                                print(dataScreenForm.hostId);
                              }
                            }

                          } else {
                            await Dialogs.alert(context, 'Error', 'You did not accept the terms and condition.');
                          }

                        } else if(!userNameStatus) {
                          await Dialogs.alert(context, 'Error', 'Please check the username!');
                        } else {
                          await Dialogs.alert(context, 'Error', 'Please check the email is already taken');
                        }
                      }





//                      if(selectedRadioTile == null) {
//                        await Dialogs.alert(context, 'Error', 'Please make  a choice of the three below');
//                      } else if(selectedRadioTile == 'createTeam') {
//                        await Dialogs.alert(context, 'Team Creation', 'Let Create a team');
//                      } else {
//
//                        if(selectedTeam == null) {
//                          await Dialogs.alert(context, 'Error', 'Please select a team');
//                        } else {
////                          _toggleSpinner(true);
////                          var result = await _authService.signUp(dataScreenForm, reporterScreenForm, selectedTeam.id);
////                          _toggleSpinner(false);
////                          print(result);
////                          if(result['status'] == 'SUCCESS' && result['httpCode'] == 200) {
////
////                          //  Navigator.pushNamed(context, HomeScreen.id);
////                          } else {
////                            await Dialogs.alert(context, 'Error', '${result['message']}');
////                          }
//
//
//                        print(reporterScreenForm);
//                        print(selectedTeam.id);
//                        print('--------');
//                        print(dataScreenForm.gender);
//                        print(dataScreenForm.fname);
//                        print(dataScreenForm.lname);
//                        print(dataScreenForm.username);
//                        print(dataScreenForm.postalCode);
//                        print(dataScreenForm.houseNumber);
//                        print(dataScreenForm.streetName);
//                        print(dataScreenForm.email);
//                        print(dataScreenForm.phoneNumber);
//                        print(dataScreenForm.password);
//                        print(dataScreenForm.town);
//                        print(dataScreenForm.state);
//                        print(dataScreenForm.hostId);
//
//
//
//                        }
//                      }
                    }),

                  ],
                ),
              ),
            ),
          ),
      ),
    );
  }
}
