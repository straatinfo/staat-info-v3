import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:straatinfoflutter/constants.dart';
import 'package:straatinfoflutter/components/rounded_button.dart';
import 'package:straatinfoflutter/screens/tab_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:straatinfoflutter/services/graph_ql_config.dart';
import 'package:straatinfoflutter/services/query_mutation.dart';


class EnterCodeScreen extends StatefulWidget {
  static const String id = 'enter_code_screen';
  @override
  _EnterCodeScreenState createState() => _EnterCodeScreenState();
}

class _EnterCodeScreenState extends State<EnterCodeScreen> {
  GraphQlConfig graphQlConfig = GraphQlConfig();
  QueryMutation queryMutation = QueryMutation();
  String code = 'john_test@test.com';

//  createAlertDialog(BuildContext context) {
//    return showDialog(context: context, builder: (context) {
//      return AlertDialog(
//        title: Text('Error'),
//      );
//    });
//  }

  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: graphQlConfig.client,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Straat.Info'),
          backgroundColor: Color(0xff4c6883),
        ),
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Center(
            child: SingleChildScrollView(
//              child: Query(options: QueryOptions(documentNode: gql(
////                queryMutation.getUsers(code)),
////              ),
////                builder: (
////                    QueryResult result, {
////                      VoidCallback refetch,
////                      FetchMore fetchMore
////                    }
////                    ) {
////                  if(result.data == null) {
////                    return Text('no data found!');
////                  }
////                  print(result.data);
////                  print(result.data['user']['email']);
////                  return Text('Sample');
////                }
////              ),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Image.asset(
                    'images/straat_info_icon.png',
                    width: 100.0,
                    height: 100.0,
                  ),
                  SizedBox(height: 8.0,),
                  Text('Enter Code',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  SizedBox(height: 8.0,),
                  TextFormField(
                    textAlign: TextAlign.center,
                    decoration: kTextFieldDecoration.copyWith(hintText: 'Enter Code'),
                    onChanged: (value) {
                         code = value;
                    },
                    validator: (value) {
                        if(value.isEmpty) {
                          print('Please enter some text');
                          return 'Please enter some text';

                        }

                        return null;
                    },
                  ),
                  SizedBox(height: 8.0,),
                  Container(
                    child: Row(
                      children: <Widget>[
                        RoundedButton(title: 'CANCEL', color: Colors.red, onPressed: () {

                        },),
                        SizedBox(width: 8.0,),
                        RoundedButton(title: 'OK', color: Colors.blue, onPressed: () {
                            print(code);
                            Navigator.pushNamed(context, TabScreen.id);
                        },
//                        setState(() {
//                          showSpinner = true;
//                        });
//
//                          print(code);

//
//                        setState(() {
//                          showSpinner = false;
//                        });

                        ),
                      ],
                    ),
                  ),
                  Text(
                      'We\'re still testing and that feedback is welcome. \n This way I hope to prevent more negative feedback online',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

