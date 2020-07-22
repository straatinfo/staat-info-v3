import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:straatinfoflutter/providers/data.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:straatinfoflutter/screens/landing_page/main_drawer.dart';
import 'package:straatinfoflutter/screens/landing_page/home_tab_screen.dart';
import 'package:straatinfoflutter/components/rounded_button.dart';
import 'package:straatinfoflutter/components/dialogs.dart';
import 'package:straatinfoflutter/backend/services/feedback_service.dart';
import 'package:straatinfoflutter/components/loading_dialog.dart';
import 'package:straatinfoflutter/screens/landing_page/home_screen.dart';

class FeedbackScreen extends StatefulWidget {
  static const String id = 'feedback_screen';
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  FeedbackService _feedbackService = FeedbackService();
  final _controller = TextEditingController();
  bool showSpinner = false;
  String feedback = '';
  String devicePlatform;

  _toggleSpinner(bool val) {
    if(mounted) {
      setState(() => showSpinner = val);
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
        backgroundColor: Color(0xff4c6883),
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text('Feedback'),
          ],
        ),
        leading: GestureDetector(
          child: Icon(Icons.chat_bubble, color: Colors.white,),
          onTap: () {
            Navigator.pushNamed(context, HomeTabScreen.id);
          },
        ),
      ),
      endDrawer: MainDrawer(),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        progressIndicator: LoadingDialog(title: 'Sending...',),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: GestureDetector(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(height: 8.0,),

                    Text('Your Feedback',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 18.0,),
                    ),
                    SizedBox(height: 8.0,),

                    TextFormField(
                      controller: _controller,
                      maxLines: 10,
                      decoration: InputDecoration(
                        hintText: 'Please write your problem with the app or hint to improve here.',
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)
                        ),
                      ),
                      onChanged: (val) {
                        feedback = val;
                      },

                    ),
                    SizedBox(height: 15.0,),
                    RoundedButton(title: 'SEND FEEDBACK', color: Color(0xFF7dbf40), onPressed: () async {
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }

                      if(feedback.isNotEmpty) {
                        _toggleSpinner(true);
                        devicePlatform = await _feedbackService.getDevicePlatform();
                        print('Device: $devicePlatform');
                        var result = await _feedbackService.sendFeedback(feedback, devicePlatform);
                        _toggleSpinner(false);
                        print(result);
                        if(!result) {
                          await Dialogs.alert(context, 'Error', 'You must be authenticated!');
                        }  else {
                          _controller.clear();
                          await Dialogs.alert(context, 'Success', 'Feedback is successfully sent!');
                          Provider.of<Data>(context, listen: false).hideMarkersInGoogleMap(false);
                          Navigator.of(context).pushNamedAndRemoveUntil(HomeScreen.id, (Route<dynamic> route) => false);
                        }
                      } else {
                        await Dialogs.alert(context, 'Error', 'Feedback field is required');
                      }


                    },),

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


//class FeedbackScreen extends StatelessWidget {
//  static const String id = 'feedback_screen';
//  String feedback;
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        backgroundColor: Color(0xff4c6883),
//        automaticallyImplyLeading: false,
//        title: Row(
//          mainAxisAlignment: MainAxisAlignment.end,
//          children: <Widget>[
//            Text('Feedback'),
//          ],
//        ),
//        leading: GestureDetector(
//          child: Icon(Icons.chat_bubble, color: Colors.white,),
//          onTap: () {
//            Navigator.pushNamed(context, HomeTabScreen.id);
//          },
//        ),
//      ),
//      endDrawer: MainDrawer(),
//      body: Padding(
//        padding: const EdgeInsets.all(8.0),
//        child: SingleChildScrollView(
//          child: GestureDetector(
//            onTap: () {
//              FocusScopeNode currentFocus = FocusScope.of(context);
//              if (!currentFocus.hasPrimaryFocus) {
//                currentFocus.unfocus();
//              }
//            },
//            child: Container(
//              child: Column(
//                crossAxisAlignment: CrossAxisAlignment.stretch,
//                children: <Widget>[
//                  SizedBox(height: 8.0,),
//
//                  Text('Your Feedback',
//                    textAlign: TextAlign.left,
//                    style: TextStyle(fontSize: 18.0,),
//                  ),
//                  SizedBox(height: 8.0,),
//
//                  TextField(
//                    maxLines: 10,
//                    decoration: InputDecoration(
//                      hintText: 'Please write your problem with the app or hint to improve here.',
//                      focusedBorder: OutlineInputBorder(
//                          borderSide: BorderSide(color: Colors.black)
//                      ),
//                      enabledBorder: OutlineInputBorder(
//                        borderSide: BorderSide(color: Colors.black)
//                      ),
//                    ),
//                    onChanged: (val) {
//                      feedback = val;
//                    },
//
//                  ),
//
//                  RoundedButton(title: 'SEND FEEDBACK', color: Color(0xFF7dbf40), onPressed: () async {
//                    FocusScopeNode currentFocus = FocusScope.of(context);
//                    if (!currentFocus.hasPrimaryFocus) {
//                      currentFocus.unfocus();
//                    }
//
//                    print('Hello');
//                  },),
//
//                ],
//              ),
//            ),
//          ),
//        ),
//      ),
//    );
//  }
//}
