import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'dart:async';
import 'package:provider/provider.dart';
import 'package:straatinfoflutter/screens/landing_page/main_drawer.dart';
import 'package:straatinfoflutter/screens/landing_page/home_tab_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:straatinfoflutter/components/rounded_button.dart';
import 'package:straatinfoflutter/screens/landing_page/reports/bottom_sheet_create_report.dart';
import 'package:straatinfoflutter/providers/data.dart';
import 'package:straatinfoflutter/backend/services/report_service.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:straatinfoflutter/components/loading_dialog.dart';
import 'package:intl/intl.dart';
import 'package:speech_bubble/speech_bubble.dart';
import 'package:straatinfoflutter/backend/model/map_pin_data.dart';


class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  ReportService _reportService = ReportService();
  List<MapInfoWindowPinData> getReportsResult = [];
  bool showSpinner = true;
  Set<Marker> _markers = HashSet<Marker>();
  Set<Marker> _oneMarker = HashSet<Marker>();
  Set<Circle> _circles = HashSet<Circle>();
  String pinAddress = '';
  GoogleMapController _mapController;
  BitmapDescriptor _markerIconNewTask;
  BitmapDescriptor _markerIconDoneTask;
  bool hideMapReports = false;
  bool customInfoWindow = false;
  MapInfoWindowPinData _selectedReport;

  _toggleSpinner(bool val) {
    if(mounted) {
      setState(() => showSpinner = val);
    }
  }
  _showCustomInfoWindow(bool val) {
    if(mounted) {
      setState(() => customInfoWindow = val);
    }
  }


  void getLocation() async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
  }

  void _getAddressFromLatLng(double lat, double long) async {
    try {
      List<Placemark> placemarkList = await Geolocator().placemarkFromCoordinates(lat, long);
      Placemark placemark = placemarkList[0];
      pinAddress = "${placemark.thoroughfare} ${placemark.subThoroughfare}, ${placemark.postalCode}, ${placemark.locality} ${placemark.country}";
      Provider.of<Data>(context, listen: false).changeCurrentAddressMap(pinAddress, lat, long);
    } catch(e) {
      print(e);
    }
  }


  void _onMapCreatedShowReports(GoogleMapController controller) async {
    _mapController = controller;
    _markerIconNewTask = await BitmapDescriptor.fromAssetImage(ImageConfiguration(), 'images/map_pin_new.png');
    _markerIconDoneTask = await BitmapDescriptor.fromAssetImage(ImageConfiguration(), 'images/map_pin_done.png');
    _circles.add(
      Circle(
          circleId: CircleId('0'),
          center: LatLng(52.0775, 4.3162),
          radius: 1180,
          strokeColor: Color(0xff4c6883),
          strokeWidth: 1,
          fillColor: Color.fromRGBO(76, 104, 131, .3)
      ),
    );

    getReportsResult = await _reportService.getAllReports();
    _markers.clear();
    if(mounted) {
      if(getReportsResult.length > 0) {
        for(MapInfoWindowPinData report in getReportsResult) {
          _markers.add(
            Marker(
              markerId: MarkerId(report.id),
              position: LatLng(report.lat, report.long),
              onTap: () {
                _selectedReport = MapInfoWindowPinData(
                  id: report.id, lat: report.lat, long: report.long,
                  status: report.status, createdAt: report.createdAt, mainCategory: report.mainCategory, imageUrl: report.imageUrl,
                );
                _showCustomInfoWindow(true);
              },
              icon: report.status == 'NEW' ?_markerIconNewTask : _markerIconDoneTask,
            ),
          );
        }
      }
    }
    _toggleSpinner(false);
  }

  void _onDragMapPin() {
    _oneMarker.clear();
    _oneMarker.add(
      Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
        draggable: true,
        markerId: MarkerId('0'),
        position: LatLng(52.0775, 4.3162),
        onDragEnd: (val) {
          _getAddressFromLatLng(val.latitude, val.longitude);
          print(val.latitude);
          print(val.longitude);
        },
      ),);
  }

  @override
  Widget build(BuildContext context) {
    print('Home screen rebuilding');
    var screenHeight = MediaQuery.of(context).size.height;
    hideMapReports = Provider.of<Data>(context).markersOnGoogleMap;
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xff4c6883),
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text('Straat.Info'),
          ],
        ),
        leading: GestureDetector(
          child: Icon(
            Icons.chat_bubble,
            color: Colors.white,
          ),
          onTap: () {
            Navigator.pushNamed(context, HomeTabScreen.id);
          },
        ),
      ),
      endDrawer: MainDrawer(),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        progressIndicator: LoadingDialog(title: 'Fetching Reports...',),
        child: Stack(
          children: <Widget>[

            GoogleMap(
            onMapCreated: _onMapCreatedShowReports,
            initialCameraPosition: CameraPosition(target: LatLng(52.0774, 4.3160), zoom: 14),
            markers: !hideMapReports ? _markers : _oneMarker,
            circles: _circles,
            zoomControlsEnabled: true,
            myLocationEnabled: true,
            onTap: (_) {
              if(customInfoWindow) {
                _showCustomInfoWindow(false);
              }
            },
          ),

            customInfoWindow ?
            Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  child: SpeechBubble(
                    width: MediaQuery.of(context).size.width * .90,
                    height: screenHeight * .20,
                    color: Colors.white,
//                    nipLocation: NipLocation.TOP,
                    nipHeight: 20.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(_selectedReport.mainCategory, style: TextStyle(fontSize: 17.0),),
                                  SizedBox(height: 10.0,),
                                  Text(_selectedReport.createdAt, style: TextStyle(fontSize: 17.0),),
                                  SizedBox(height: 10.0,),
                                  Text('View Report', style: TextStyle(fontSize: 17.0),),
                                ],
                              ),
                            ),
                          ),

                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: _selectedReport.imageUrl != '' ? Container(
                                decoration: BoxDecoration(
                                  color: Color(0xff4c6883),
                                  image: DecorationImage(
                                    image: NetworkImage(_selectedReport.imageUrl),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ) :
                              Container(
                                color: Color(0xff4c6883),
                                constraints: BoxConstraints.expand(),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text('No Photo', style: TextStyle(color: Colors.white, fontSize: 20.0),),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ) :
            SizedBox(height: 0.0,),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  children: <Widget>[
                    !hideMapReports ?
                    SizedBox(
                      width: 50.0,
                      height: 50.0,
                      child: FloatingActionButton(
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(HomeScreen.id, (Route<dynamic> route) => false);
                        },
                        child: Icon(Icons.refresh, size: 30.0,),
                        backgroundColor:Color(0xff4c6883),
                      ),
                    ) :
                    SizedBox(height: 0.0,),
                  ],
                ),
              ),
            ),

            Container(
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: RoundedButton(title: 'SEND REPORT', color: Color(0xFF7dbf40), onPressed: () {
                _onDragMapPin();
                getLocation();
                _getAddressFromLatLng(52.0775, 4.3162);
                Provider.of<Data>(context, listen: false).hideMarkersInGoogleMap(true);
                scaffoldKey.currentState.showBottomSheet((context) => GestureDetector(child: BottomSheetCreateReport(),
                  //To disable dragging of bottom sheet
                  onVerticalDragDown: (_) {},
                ));
              },),
            ),
          ],
        ),
      ),
    );
  }
}
