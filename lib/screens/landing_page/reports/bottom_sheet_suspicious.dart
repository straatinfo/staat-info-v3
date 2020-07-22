import 'package:flutter/material.dart';
import 'dart:io' show File;
import 'package:provider/provider.dart';
import 'package:straatinfoflutter/providers/data.dart';
import 'package:straatinfoflutter/components/rounded_button.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:straatinfoflutter/backend/model/category.dart';
import 'package:straatinfoflutter/backend/services/report_service.dart';
import 'package:straatinfoflutter/components/dialogs.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:straatinfoflutter/components/loading_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:straatinfoflutter/backend/services/imageUpload_service.dart';
import 'package:straatinfoflutter/screens/landing_page/reports/bottom_sheet_report_options.dart';
import 'package:straatinfoflutter/screens/landing_page/home_screen.dart';



class BottomSheetSuspicious extends StatefulWidget {
  @override
  _BottomSheetSuspiciousState createState() => _BottomSheetSuspiciousState();
}
class _BottomSheetSuspiciousState extends State<BottomSheetSuspicious> {
  ReportService _reportService = ReportService();
  ImageUploadService _imageUploadService = ImageUploadService();
  final _picker = ImagePicker();
  bool showSpinner = true;
  dynamic mainCategoryResult;
  Category selectedMainCategory;
  List<Category> categories = [];
  List<int> numberList = [];
  bool emergencyNotif = false;
  bool peopleInvolved = false;
  int numPeopleInvolved;
  String personDetails;
  bool vehicleInvolved = false;
  int numVehicleInvolved;
  String vehicleDetails;
  String composeReport;
  PickedFile _imageOne;
  PickedFile _imageTwo;
  PickedFile _imageThree;
  bool isLoadingPhoto = false;
  String idImageOne;
  String idImageTwo;
  String idImageThree;
  String currentLocationAddress;
  double currentLat;
  double currentLong;
  String hostId;
  String teamId;
  List<String> attachmentIDList = [];

  @override
  void initState() {
    super.initState();
    _fetchMainCategories();
    _createNumberList();
  }
  void _fetchMainCategories() async {
    mainCategoryResult = await _reportService.getMainCategories();
    for(dynamic cat in mainCategoryResult) {
      categories.add(Category(id: cat['id'], category: cat['name']));
      print(cat['id'] + '' +cat['name']);
    }
    _toggleSpinner(false);
  }
  void _toggleSpinner(bool val) {
    print('Mounted $mounted');
    if(mounted) {
      setState(() => showSpinner = val);
    }
  }

  void _toggleIsLoadingPhoto(bool val) {
    if(mounted) {
      setState(() => isLoadingPhoto = val);
    }
  }

  void _setTheStateOfThePhotoSwitch(String photoNumber, String photoId, PickedFile photoDetails) {
    if(mounted) {
      switch(photoNumber) {
        case 'one': {
          idImageOne = photoId;
          setState(() => _imageOne = photoDetails);
        }
        break;
        case 'two': {
          idImageTwo = photoId;
          setState(() => _imageTwo = photoDetails);
        }
        break;
        case 'three': {
          idImageThree = photoId;
          setState(() => _imageThree = photoDetails);
        }
        break;
      }
    }
  }

  void _onRemovePhotoSetTheState(String photoNumber) {
    if(mounted) {
      switch(photoNumber) {
        case 'one': {
          idImageOne = null;
          setState(() => _imageOne = null);
        }
        break;
        case 'two': {
          idImageTwo = null;
          setState(() => _imageTwo = null);
        }
        break;
        case 'three': {
          idImageThree = null;
          setState(() => _imageThree = null);
        }
        break;
      }
    }
  }

  void _createNumberList() {
    var i = 0;
    while(i < 101) {
      numberList.add(i);
      i++;
    }
  }

  void _pickImageFromGallery(String photoNumber) async {
    PickedFile imageFromGallery;
    // If the photo access is not yet granted it will prompt, otherwise nothing will happen
    await Permission.photos.request();
    var permissionStatusGallery = await Permission.photos.status;
    if(permissionStatusGallery.isGranted) {
      imageFromGallery = await _picker.getImage(source: ImageSource.gallery);
      if(imageFromGallery != null) {
        _toggleIsLoadingPhoto(true);
        var result = await _imageUploadService.uploadImage(File(imageFromGallery.path));
        _toggleIsLoadingPhoto(false);
        if(result['httpCode'] >= 200 && result['httpCode'] < 400) {
          _setTheStateOfThePhotoSwitch(photoNumber, result['id'], imageFromGallery);
        } else {
          await Dialogs.alert(context, 'Error', 'Server Error');
        }
      }
    }
  }

  void _captureImageFromCamera(String photoNumber) async {
    PickedFile imageFromCamera;
    // If the photo access is not yet granted it will prompt, otherwise nothing will happen
    await Permission.camera.request();
    var permissionStatusCamera = await Permission.camera.status;
    if(permissionStatusCamera.isGranted) {
      imageFromCamera = await _picker.getImage(source: ImageSource.camera);
      if(imageFromCamera != null) {
        _toggleIsLoadingPhoto(true);
        var result = await _imageUploadService.uploadImage(File(imageFromCamera.path));
        _toggleIsLoadingPhoto(false);
        if(result['httpCode'] >= 200 && result['httpCode'] < 400) {
          _setTheStateOfThePhotoSwitch(photoNumber, result['id'], imageFromCamera);
        } else {
          await Dialogs.alert(context, 'Error', 'Server Error');
        }
      }
    }
  }



  Future<void> _showPictureDialog(String imageNumber, BuildContext context) async {
    final action = await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            title: Text('Select Action', style: TextStyle(fontSize: 18.0),),
            titlePadding: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0, bottom: 1.0),
            content: Container(
              height: 105.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  FlatButton(
                    padding: EdgeInsets.only(left: 17.0, right: 17.0, top: 10.0, bottom: 10.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                        child: Text('Select photo from gallery',  style: TextStyle(fontSize: 15.0),),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _pickImageFromGallery(imageNumber);
                    },
                  ),
                  FlatButton(
                    padding: EdgeInsets.only(left: 17.0, right: 17.0, top: 10.0, bottom: 10.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Capture photo from camera',  style: TextStyle(fontSize: 15.0),),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _captureImageFromCamera(imageNumber);

                    },
                  ),
                ],
              ),
            ),
            contentPadding: EdgeInsets.only(top: 1.0),
          );
        });
    return action;
  }

  @override
  Widget build(BuildContext context) {
    print('Suspicious rebuilding...');
    print('ID 1 $idImageOne');
    print('ID 2 $idImageTwo');
    print('ID 3 $idImageThree');
    var appBar = AppBar();
    var bottomSheetHeight = (MediaQuery.of(context).size.height - appBar.preferredSize.height) * .80;
    var bottomSheetWidth = MediaQuery.of(context).size.width - 50;
    return Container(
      height: bottomSheetHeight,
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(40.0),
            child: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Color(0xFFbdcadc),
              leading: GestureDetector(
                child: Icon(Icons.arrow_back),
                onTap: () {
                  Navigator.pop(context);
                  showBottomSheet(context: context, builder: (context) => GestureDetector(child: BottomSheetReportOptions(),
                    //To disable dragging of bottom sheet
                    onVerticalDragDown: (_) {},
                  ));
                }
              ),
              title: Text('Suspicious', style: TextStyle(color: Colors.black),),
              actions: <Widget>[
                IconButton(icon: Icon(Icons.close), onPressed: () {
                  Navigator.pop(context);
                  Provider.of<Data>(context, listen: false).hideMarkersInGoogleMap(false);
                }),
              ],
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
                    padding: const EdgeInsets.all(5.0),
                    child: Consumer<Data>(
                        builder: (_, data, __) => data.mapCurrentAddress != null ? Text('Location: ${data.mapCurrentAddress}',
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 17.0, color: Colors.black),
                        ) :
                        SpinKitThreeBounce(color: Colors.green, size: 30.0,)
                    ),
                  ),
                ),
              ),
            ),
            body: ModalProgressHUD(
              inAsyncCall: showSpinner,
              progressIndicator: LoadingDialog(title: 'Loading...',),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[

                        SizedBox(height: 5.0,),
                        Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: Color(0xFF98dcff),),),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButtonHideUnderline(
                              child: Consumer<Data>(
                                builder: (_, data, __) => DropdownButton(
                                  isExpanded: true,
                                  hint: Text('Select Main Category'),
                                  value: data.selectedMainCategory,
                                  items: categories.map((Category category) {
                                    return DropdownMenuItem<Category>(
                                        value: category,
                                        child: Text(category.category));
                                  }).toList(),
                                  onChanged: (Category value) {
                                    selectedMainCategory = value;
                                    Provider.of<Data>(context, listen: false).changeSelectedMainCategory(selectedMainCategory);
                                  },
                                ),
                              ),
                            ),
                          ),),

                        SizedBox(height: 10.0,),
                        Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: Color(0xFF98dcff),),),
                          child: Consumer<Data>(
                            builder: (_, data, __) => SwitchListTile(
                              activeColor: Color(0xFFd41a5e),
                              inactiveThumbColor: Color(0xFFececec),
                              title: Text('Emergency Notification'),
                              value: data.suspiciousEmergencyNotif,
                              onChanged: (bool value) async {
                                emergencyNotif = value;
                                Provider.of<Data>(context, listen: false).changeSampleNotif('suspiciousEmergencyNotif', emergencyNotif);
                                if(emergencyNotif) {
                                  await Dialogs.alert(context, 'Urgent?', 'Urgent? First Call 112');
                                }
                              },
                            ),
                          ),
                        ),

                        SizedBox(height: 10,),
                        Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: Color(0xFF98dcff),),),
                          child: Consumer<Data>(
                            builder: (_, data, __) => SwitchListTile(
                              activeColor: Color(0xFFd41a5e),
                              inactiveThumbColor: Color(0xFFececec),
                              title: Text('Are there people involved?'),
                              value: data.suspiciousPeopleNotif,
                              onChanged: (bool value) {
                                peopleInvolved = value;
                                Provider.of<Data>(context, listen: false).changeSampleNotif('suspiciousPeopleNotif', peopleInvolved);
                              },
                            ),
                          ),
                        ),

                        SizedBox(height: 10.0,),
                        Consumer<Data>(
                            builder: (_, data, ___) => !data.suspiciousPeopleNotif ? SizedBox(height: .1,) :
                            Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: Color(0xFF98dcff),),),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    value: data.peopleInvolved,
                                    elevation: 16,
                                    isExpanded: true,
                                    hint: Text('0'),
                                    items: numberList
                                        .map<DropdownMenuItem<int>>((int num) {
                                      return DropdownMenuItem<int>(
                                        value: num,
                                        child: Text(num.toString()),
                                      );
                                    }).toList(),
                                    onChanged: (int intVal) {
                                      numPeopleInvolved = intVal;
                                      Provider.of<Data>(context, listen: false).changeNumDropdown('peopleInvolved', numPeopleInvolved);
                                    },
                                  ),
                                ),
                              ),
                            ),
                        ),

                        SizedBox(height: 10,),
                        Container(
                          child: Consumer<Data>(
                            builder: (_, data, __) => !data.suspiciousPeopleNotif ? SizedBox(height: .1,) :
                            TextField(
                              maxLines: 4,
                              decoration: InputDecoration(
                                hintText: 'Enter here the characteristic of the person(s) involved and, such as height, gender, hair, color, mustache, beard, glasses, clothing, posture, tattoo or other striking details',
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFF98dcff)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFF98dcff)),
                                ),
                              ),
                              onChanged: (val) {
                                personDetails = val;
                              },

                            ),
                          ),
                        ),

                        SizedBox(height: 10,),
                        Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: Color(0xFF98dcff),),),
                          child: Consumer<Data>(
                            builder: (_, data, __) => SwitchListTile(
                              activeColor: Color(0xFFd41a5e),
                              inactiveThumbColor: Color(0xFFececec),
                              title: Text('Are vehicle involved?'),
                              value: data.suspiciousVehicleNotif,
                              onChanged: (bool value) {
                                vehicleInvolved = value;
                                Provider.of<Data>(context, listen: false).changeSampleNotif('suspiciousVehicleNotif', vehicleInvolved);
                              },
                            ),
                          ),
                        ),

                        SizedBox(height: 10,),
                        Consumer<Data>(
                          builder: (_, data, __) => !data.suspiciousVehicleNotif ? SizedBox(height: .1,) :
                          Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: Color(0xFF98dcff),),),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  value: data.vehicleInvolved,
                                  elevation: 16,
                                  isExpanded: true,
                                  hint: Text('0'),
                                  items: numberList
                                      .map<DropdownMenuItem<int>>((int num) {
                                    return DropdownMenuItem<int>(
                                      value: num,
                                      child: Text(num.toString()),
                                    );
                                  }).toList(),
                                  onChanged: (int intVal) {
                                    numVehicleInvolved = intVal;
                                    Provider.of<Data>(context, listen: false).changeNumDropdown('vehicleInvolved', numVehicleInvolved);
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 10,),
                        Container(
                          child: Consumer<Data>(
                            builder: (_, data, __) => !data.suspiciousVehicleNotif ? SizedBox(height: .1,) :
                            TextField(
                              enableInteractiveSelection: true,
                              maxLines: 4,
                              decoration: InputDecoration(
                                hintText: 'Enter the characteristics of the means of transport involved, such as license plate, color, brand and type number, eye-catching stickers, etc.',
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFF98dcff)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFF98dcff)),
                                ),
                              ),
                              onChanged: (val) {
                                vehicleDetails = val;
                              },

                            ),

                          ),
                        ),

                        SizedBox(height: 10,),
                        TextField(
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: 'vul hier uw tekst in',
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF98dcff)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF98dcff)),
                            ),
                          ),
                          onChanged: (val) {
                            composeReport = val;
                          },
                        ),

                        SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: Text('Foto \'s maken of uploaden:', style: TextStyle(fontSize: 20.0),),
                          ),
                        ),

                        isLoadingPhoto ?
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[

                              Text('Uploading photo ', style: TextStyle(fontSize: 12.0),),
                              SpinKitThreeBounce(color: Colors.green, size: 12.0,),
                            ],
                          ),
                        ) :
                        SizedBox(height: .1,),


                        SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              height: 200.0,
                              width: bottomSheetWidth / 3,
                              decoration: _imageOne == null ?
                              BoxDecoration(color: Color(0xFF98dcff),) :
                              BoxDecoration(
                                color: Color(0xFF98dcff),
                                image: DecorationImage(
                                  image: FileImage(File(_imageOne.path)),
//                                  image: Image.file(File(_imageOne.path)),
                                  fit: BoxFit.contain,
                                ),
                              ),
                              child: _imageOne == null ?
                              Align(
                                alignment: Alignment.center,
                                child: CircleAvatar(
                                  backgroundColor: Color(0xFF76b81a),
                                  radius: 20,
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: Icon(Icons.add, size: 25.0,),
                                    color: Colors.white,
                                    onPressed: () {
                                      _showPictureDialog('one', context);
                                    },
                                  ),
                                ),
                              ) :
                              Column(
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.red,
                                      radius: 13,
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        icon: Icon(Icons.clear, size: 15.0,),
                                        color: Colors.white,
                                        onPressed: () {
                                          _onRemovePhotoSetTheState('one');
                                        },
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: CircleAvatar(
                                        backgroundColor: Color(0xFF76b81a),
                                        radius: 15,
                                        child: IconButton(
                                          padding: EdgeInsets.zero,
                                          icon: Icon(Icons.edit, size: 20.0,),
                                          color: Colors.white,
                                          onPressed: () {
                                            _showPictureDialog('one', context);
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              height: 200.0,
                              width: bottomSheetWidth / 3,
                              decoration: _imageTwo == null ?
                              BoxDecoration(color: Color(0xFF98dcff),) :
                              BoxDecoration(
                                color: Color(0xFF98dcff),
                                image: DecorationImage(
                                  image: FileImage(File(_imageTwo.path)),
                                  fit: BoxFit.contain,
//                                  image: Image.file(File(_imageOne.path)),
//                                  fit: BoxFit.fill,
                                ),
                              ),
                              child: _imageTwo == null ?
                                Align(
                                  alignment: Alignment.center,
                                  child: CircleAvatar(
                                    backgroundColor: Color(0xFF76b81a),
                                    radius: 20,
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      icon: Icon(Icons.add, size: 25.0,),
                                      color: Colors.white,
                                      onPressed: () {
                                        _showPictureDialog('two', context);
                                      },
                                    ),
                                  ),
                                ) :
                                Column(
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.red,
                                        radius: 13,
                                        child: IconButton(
                                          padding: EdgeInsets.zero,
                                          icon: Icon(Icons.clear, size: 15.0,),
                                          color: Colors.white,
                                          onPressed: () {
                                            _onRemovePhotoSetTheState('two');
                                          },
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: CircleAvatar(
                                          backgroundColor: Color(0xFF76b81a),
                                          radius: 15,
                                          child: IconButton(
                                            padding: EdgeInsets.zero,
                                            icon: Icon(Icons.edit, size: 20.0,),
                                            color: Colors.white,
                                            onPressed: () {
                                              _showPictureDialog('two', context);
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                            ),

                            Container(
                              height: 200.0,
                              width: bottomSheetWidth / 3,
                              decoration: _imageThree == null ?
                              BoxDecoration(color: Color(0xFF98dcff),) :
                              BoxDecoration(
                                color: Color(0xFF98dcff),
                                image: DecorationImage(
                                  image: FileImage(File(_imageThree.path)),
//                                  image: Image.file(File(_imageOne.path)),
                                  fit: BoxFit.contain,
                                ),
                              ),
                              child: _imageThree == null ?
                              Align(
                                alignment: Alignment.center,
                                child: CircleAvatar(
                                  backgroundColor: Color(0xFF76b81a),
                                  radius: 20,
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: Icon(Icons.add, size: 25.0,),
                                    color: Colors.white,
                                    onPressed: () {
                                      _showPictureDialog('three', context);
                                    },
                                  ),
                                ),
                              ) :
                              Column(
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.red,
                                      radius: 13,
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        icon: Icon(Icons.clear, size: 15.0,),
                                        color: Colors.white,
                                        onPressed: () {
                                          _onRemovePhotoSetTheState('three');

                                        },
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: CircleAvatar(
                                        backgroundColor: Color(0xFF76b81a),
                                        radius: 15,
                                        child: IconButton(
                                          padding: EdgeInsets.zero,
                                          icon: Icon(Icons.edit, size: 20.0,),
                                          color: Colors.white,
                                          onPressed: () {
                                            _showPictureDialog('three', context);
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),



                        RoundedButton(title: 'VESTUUR MELDING', color: Color(0xFF7dbf40), onPressed: () async{
                          FocusScopeNode currentFocus = FocusScope.of(context);
                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }
                          if(selectedMainCategory == null) {
                            await Dialogs.alert(context, 'Warning!', 'Main Category is required field!');
                          } else {
                            if(composeReport == null) {
                              await Dialogs.alert(context, 'Warning!', 'Description is required field');
                            } else {
                              attachmentIDList = _reportService.imageIdPutToArray(idImageOne, idImageTwo, idImageThree);
                              currentLocationAddress = Provider.of<Data>(context, listen: false).mapCurrentAddress;
                              currentLat = Provider.of<Data>(context, listen: false).latitude;
                              currentLong = Provider.of<Data>(context, listen: false).longitude;
                              hostId = "5a7b485a039e2860cf9dd19a";
                              teamId = "5ec8fefeb0462e0017f83510";
                              _toggleSpinner(true);
                              var sendReportTypeBResult = await _reportService.sendReportTypeB(
                                  selectedMainCategory.category, composeReport, currentLocationAddress, currentLat, currentLong,
                                  selectedMainCategory.id, emergencyNotif, hostId, teamId, attachmentIDList, vehicleInvolved,
                                  numVehicleInvolved, vehicleDetails, peopleInvolved, numPeopleInvolved, personDetails
                              );
                              _toggleSpinner(false);
                              if(sendReportTypeBResult >= 200 && sendReportTypeBResult < 400){
                                await Dialogs.alert(context, 'Success', 'Thank you for you report! From now on everybody can see the report in the app. '
                                    'If the report is about public space, it is also mailed to the host');
                                Provider.of<Data>(context, listen: false).hideMarkersInGoogleMap(false);
                                Navigator.of(context).pushNamedAndRemoveUntil(HomeScreen.id, (Route<dynamic> route) => false);
                              } else {
                                await Dialogs.alert(context, 'Error', 'Server Error');
                              }

//                              print('Main Category: $mainCategoryVar');
//                              print('Reports: $composeReport');
//                              print('Location: $currentLocationAddress');
//                              print('Lat: $currentLat');
//                              print('Long: $currentLong');
//                              print('Main Category ID: $mainCategoryVarId');
//                              print('Emergency: $emergencyNotif');
//                              print('HostId: $hostId');
//
//                              print('People: $peopleInvolved');
//                              print('People #: $numPeopleInvolved');
//                              print('People Details: $personDetails');
//                              print('Vehicle: $vehicleInvolved');
//                              print('Vehicle #: $numVehicleInvolved');
//                              print('Vehicle Details: $vehicleDetails');

                            }

                          }
                        },),


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

