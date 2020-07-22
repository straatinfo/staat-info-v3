import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:straatinfoflutter/providers/data.dart';
import 'package:straatinfoflutter/components/rounded_button.dart';
import 'package:straatinfoflutter/components/dialogs.dart';
import 'package:straatinfoflutter/screens/landing_page/reports/bottom_sheet_suspicious.dart';
import 'package:straatinfoflutter/screens/landing_page/reports/bottom_sheet_public.dart';
import 'package:straatinfoflutter/screens/landing_page/reports/bottom_sheet_create_report.dart';

class BottomSheetReportOptions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appBar = AppBar();
    var bottomSheetHeight = (MediaQuery.of(context).size.height - appBar.preferredSize.height) * .40;
    return Container(
      height: bottomSheetHeight,
      child: Column(
        children: <Widget>[
          Container(
              height: 40.0,
              color: Color(0xFFbdcadc),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
//                  IconButton(icon: Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
                  IconButton(icon: Icon(Icons.arrow_back, color: Colors.white,), onPressed: () =>  {
                    Navigator.pop(context),
                    showBottomSheet(context: context, builder: (context) => GestureDetector(child: BottomSheetCreateReport(),
                      //To disable dragging of bottom sheet
                      onVerticalDragDown: (_) {},
                    )),
                  }),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(icon: Icon(Icons.clear, color: Colors.white,), onPressed: () {
                        Navigator.pop(context);
                        Provider.of<Data>(context, listen: false).hideMarkersInGoogleMap(false);
                      }),
                    ),
                  ),
                ],
              )
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: RoundedButton(title: 'SUSPICIOUS SITUATION', color:  Color(0xFF7dbf40), onPressed: () {
                          Navigator.pop(context);
                          Provider.of<Data>(context, listen: false).resetSuspiciousForm();
                          showBottomSheet(context: context, builder: (context) => GestureDetector(child: BottomSheetSuspicious(),
                            //To disable dragging of bottom sheet
                            onVerticalDragDown: (_) {},
                          ));

                        },),
                      ),
                      FlatButton(child: Icon(Icons.help_outline, size: 55.0, color: Color(0xFF4f6a85),), onPressed: () async {
                        await Dialogs.alert(context, 'Suspicious Situation', 'Here you\'re able to share a situation that mig be suspicious with other members of your team. '
                            'At the moment other members agree with you, that is needed looks suspicious call the police or other relevant organization. Emergency? '
                            'First call 112 before continuing to use this app!');
                      },),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: RoundedButton(title: 'PUBLIC SPACE', color:  Color(0xFF7dbf40), onPressed: () {
                          Navigator.pop(context);
                          Provider.of<Data>(context, listen: false).resetPublicForm();
                          showBottomSheet(context: context, builder: (context) => GestureDetector(child: BottomSheetPublic(),
                            //To disable dragging of bottom sheet
                            onVerticalDragDown: (_) {},
                          ));
                        },),
                      ),
                      FlatButton(child: Icon(Icons.help_outline, size: 55.0, color: Color(0xFF4f6a85),), onPressed: () async {
                        await Dialogs.alert(context, 'Public Space', 'Here you\'re able to share a situation that mig be suspicious with other members of your team. '
                            'At the moment other members agree with you, that is needed looks suspicious call the police or other relevant organization. Emergency? '
                            'First call 112 before continuing to use this app!');
                      },),
                    ],
                  ),
                ),

              ],
            ),
          ),


        ],
      ),
    );
  }
}
