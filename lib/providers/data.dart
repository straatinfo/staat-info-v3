import 'package:flutter/material.dart';
import 'package:straatinfoflutter/backend/model/data_registration.dart';
import 'package:straatinfoflutter/backend/model/category.dart';
import 'package:straatinfoflutter/backend/model/postal_code_address.dart';

class Data extends ChangeNotifier {
  //ok
  bool registrationTerm = false;
  DataRegistration registrationData;
  bool registrationIsUserNameValid = false;
  String registrationCompleteUsername;
  bool registrationIsEmailValid = false;
  PostalCodeAddress registrationPostalCodeAddress;
  bool registrationReportValue;
  String mapCurrentAddress;

  bool suspiciousEmergencyNotif = false;
  bool suspiciousPeopleNotif = false;
  bool suspiciousVehicleNotif = false;
  Category selectedMainCategory;
  Category selectedSubCategory;
  int peopleInvolved;
  int vehicleInvolved;
  double latitude;
  double longitude;
  bool markersOnGoogleMap = false;

  //ok
  void fillTerms(bool val) {
    registrationTerm = val;
    notifyListeners();
  }
  //ok
  void fillUpRegistrationData(DataRegistration newRegistration) {
    registrationData = newRegistration;
    notifyListeners();
  }
  //ok
  void updateUserNameStatus(bool val) {
    registrationIsUserNameValid = val;
    notifyListeners();
  }

  //ok
  void updateCompleteUsername(String val) {
    registrationCompleteUsername = val;
    notifyListeners();
  }

  //ok
  void updateEmailStatus(bool val) {
    registrationIsEmailValid = val;
    notifyListeners();
  }
  // ok
  void updatePostalCodeAddress(PostalCodeAddress newAddress) {
    registrationPostalCodeAddress = newAddress;
    notifyListeners();
  }

  //ok
  void fillUpReporterData(bool newVal) {
    registrationReportValue = newVal;
    notifyListeners();
  }

  //ok
  void resetRegistrationForm() {
    registrationTerm = false;
    registrationIsUserNameValid = false;
    registrationCompleteUsername = null;
    registrationIsEmailValid = false;
    registrationPostalCodeAddress = null;
    registrationData = null;
    registrationReportValue = null;
    notifyListeners();
  }
//ok
  void changeCurrentAddressMap(String newAddress, double lat, double long) {
    mapCurrentAddress = newAddress;
    latitude = lat;
    longitude = long;
    notifyListeners();
  }

  void changeSelectedMainCategory(Category newMainCategory) {
    selectedMainCategory = newMainCategory;
    notifyListeners();
  }

  void changeSelectedSubCategory(Category newSubCategory) {
    selectedSubCategory = newSubCategory;
    notifyListeners();
  }



  void changeNumDropdown(String nameDropdown, int newPeopleValue) {
    switch(nameDropdown) {
      case 'peopleInvolved':
        peopleInvolved = newPeopleValue;
        break;
      case 'vehicleInvolved':
        vehicleInvolved = newPeopleValue;
        break;
    }
    notifyListeners();
  }


  void changeSampleNotif(String tileValue, bool newTileValue) {
    switch(tileValue) {
      case 'suspiciousEmergencyNotif':
        suspiciousEmergencyNotif = newTileValue;
        break;
      case 'suspiciousPeopleNotif':
        suspiciousPeopleNotif = newTileValue;
        break;
      case 'suspiciousVehicleNotif':
        suspiciousVehicleNotif = newTileValue;
        break;
    }
    notifyListeners();
  }

  void resetSuspiciousForm() {
    selectedMainCategory = null;
    peopleInvolved = null;
    vehicleInvolved = null;
    suspiciousEmergencyNotif = false;
    suspiciousPeopleNotif = false;
    suspiciousVehicleNotif = false;
    notifyListeners();
  }

  void resetPublicForm() {
    selectedMainCategory = null;
    selectedSubCategory = null;
    suspiciousEmergencyNotif = false;
    notifyListeners();
  }

  void hideMarkersInGoogleMap(bool val) {
    markersOnGoogleMap = val;
    notifyListeners();
  }



}