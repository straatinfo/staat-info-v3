import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:straatinfoflutter/providers/data.dart';
import 'package:straatinfoflutter/utils/constants.dart';
import 'package:straatinfoflutter/components/rounded_button.dart';
import 'package:straatinfoflutter/screens/landing_page/reports/bottom_sheet_report_options.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class BottomSheetCreateReport extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('Maak melding aan rebuilding');
    var appBar = AppBar();
    var bottomSheetHeight = (MediaQuery.of(context).size.height - appBar.preferredSize.height) * .40;
    return Container(
      height: bottomSheetHeight,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(40.0),
          child: AppBar(
            backgroundColor: Color(0xFFbdcadc),
            automaticallyImplyLeading: false,
            leading: GestureDetector(
              child: Icon(Icons.arrow_back),
              onTap: () {
                Navigator.pop(context);
                Provider.of<Data>(context, listen: false).hideMarkersInGoogleMap(false);
              },
            ),
          ),
        ),
        body: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(70.0),
            child: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              flexibleSpace: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 5.0, right: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Melding op deze locatie:',
                        textAlign: TextAlign.left,
                        style: kLabelInInputFieldDecoration,
                      ),
                      Consumer<Data>(
                          builder: (_, data, __) => data.mapCurrentAddress != null ?
                          Text('${data.mapCurrentAddress}',
                            textAlign: TextAlign.left,
                            style: kLabelInInputFieldDecoration,
                          ) :
                          SpinKitThreeBounce(color: Colors.green, size: 30.0,)
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                RoundedButton(title: 'MAAK MELDING AAN', color: Color(0xFF7dbf40), onPressed: () {
                  Navigator.pop(context);
                  showBottomSheet(context: context, builder: (context) => GestureDetector(child: BottomSheetReportOptions(),
                    //To disable dragging of bottom sheet
                    onVerticalDragDown: (_) {},
                  ));

                },),
                Text('You can put the blue pointer on a different \n place on the map',
                  textAlign: TextAlign.center,
                  style: kLabelInInputFieldDecoration,
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

