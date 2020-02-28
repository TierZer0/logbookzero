import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;
import 'dart:convert' as convert;
import 'package:intl/intl.dart';

import '../services/auth.dart';

import '../models/log_model.dart';
import '../models/doc_model.dart';

class DataService {

  final Firestore _db = Firestore.instance;
  //FlightLog log = new FlightLog();

 
  getLogbook() async {
    var user = authService.currentUser;

    return _db.collection('users').document(user).collection('logbook');
  }

  addLogbookImage(File file) async {
    var user = authService.currentUser;
    
    StorageReference ref = FirebaseStorage.instance.ref().child(user + "/").child(path.basename(file.path));
    StorageUploadTask uploadTask = ref.putFile(file);

    return (await (await uploadTask.onComplete).ref.getDownloadURL()).toString();
  }

  scanLogbookImage(request) async {
    var url;
    if (Platform.isIOS) {
      url = "https://vision.googleapis.com/v1/images:annotate?key=AIzaSyBNqTyDDRsF2rLdTfVapM6aZiQHXoAylJ0";
    } else if (Platform.isAndroid) {
      url = "https://vision.googleapis.com/v1/images:annotate?key=AIzaSyDUGwCRMhGtma5msf_BzmyF6GBORmw702c";
    }
    
    return http.post(
      url,
      body: request
    ).then((response) {
      convert.jsonDecode(response.body);
    });
  }

  void addDocStatus(doc, String status) {
    var user = authService.currentUser;

    _db.collection('users').document(user).collection('flightDocuments').document(doc['DocName'] + "_" + DateFormat.yMMMM().format(doc['DateIssued'])).setData({
      'Status' : status
    }, merge: true);
  }

  getDocumentInfo(document) {

    _db.collection('flightDocuments').where('Document' , isEqualTo: document).snapshots().listen((data) => {
      data.documents.forEach((doc) => {
        print(doc)
      })
    });

    //return document;
  }

  void addNewFlightDocument(Document doc) async {
    var user = authService.currentUser;

    DocumentReference ref = _db.collection('users').document(user);

    ref.collection('flightDocuments').document(doc.docName + "_" + DateFormat.yMMMM().format(doc.dateIssued)).setData({
      'DocName' : doc.docName != null ? doc.docName : "",
      'DateIssued' : doc.dateIssued != null ? doc.dateIssued : 0
    });
  }

  void removeDocument(doc) async {
    var user = authService.currentUser;

    var name = doc['DocName'] + "_" + DateFormat.yMMMM().format(doc['DateIssued']);
    Firestore.instance.collection('users').document(user).collection('flightDocuments').document(name).delete();
  }

  void removeLog(log) async {
    var user = authService.currentUser;

    var name = log['AircraftRegistration'] + "_" + DateFormat.yMMMd().format(log['FlightDate']);
    print(name);
    Firestore.instance.collection('users').document(user).collection('logbook').document(name).delete();
  }

  checkNull(value) {
    if (value != null) {
      return value;
    } else {
      return 0;
    }
  }

  getTotalHours(FlightLog log) async {
    var user = authService.currentUser;
    var total;
    return _db.collection('users').document(user).get().then((var doc) {
      if (doc.exists) {
        if (doc.data['totalHours'] != null) {
          int prevTotal = doc.data['totalHours'];
          total =  prevTotal + checkNull(log.singleEngineDayDual) + checkNull(log.singleEngineDayPilot) + checkNull(log.singleEngineNightDual) + checkNull(log.singleEngineNightPilot) + checkNull(log.multiEngineDayCopilot) + checkNull(log.multiEngineDayDual) + checkNull(log.multiEngineDayPilot) + checkNull(log.multiEngineNightCopilot) + checkNull(log.multiEngineNightDual) + checkNull(log.multiEngineNightPilot);
          return total;
        } else {
          return null;
        }
        
      } else {
        return null;
      }
    });
  }

  void updateTotalHours(hours) async {
    var user = authService.currentUser;
    _db.collection('users').document(user).setData({
      "totalHours" : hours
    }, merge: true);
  }

  void addNewFlightLog(FlightLog log) async {
    var user = authService.currentUser;

    DocumentReference ref = _db.collection('users').document(user);

    //var hours = getTotalHours(log);
    getTotalHours(log).then((response) {
      //print(response)
      updateTotalHours(response);
    });
    
    var dateString = DateFormat.MMMM().format(log.flightDate) + " " + DateFormat.d().format(log.flightDate) +  " " + DateFormat.y().format(log.flightDate);
    ref.collection('logbook').document(log.aircraftRegistration + "_" + dateString).setData({
      'AircraftRegistration' : log.aircraftRegistration != null ? log.aircraftRegistration : "",
      'AircraftType' : log.aircraftType != null ? log.aircraftType : "",
      'CrossCountryDayDual' : log.crossCountryDayDual != null ? log.crossCountryDayDual : 0,
      'CrossCountryDayPilot' : log.crossCountryDayPilot != null ? log.crossCountryDayPilot : 0,
      'CrossCountryNightDual' : log.crossCountryNightDual != null ? log.crossCountryNightDual : 0,
      'CrossCountryNightPilot' : log.crossCountryNightPilot != null ? log.crossCountryNightPilot : 0,
      'FlightDate' : log.flightDate != null ? log.flightDate : "",
      'FlightNotes' : log.flightNotes != null ? log.flightNotes : "",
      'FromCode' : log.fromCode != null ? log.fromCode : "",
      'InstrumentCloud' : log.instrumentCloud != null ? log.instrumentCloud : 0,
      'InstrumentHood' : log.instrumentHood != null ? log.instrumentHood : 0,
      'InstrumentSim' : log.instrumentSim != null ? log.instrumentSim : 0,
      'MultiEngineDayCopilot' : log.multiEngineDayCopilot != null ? log.multiEngineDayCopilot : 0,
      'MultiEngineDayDual' : log.multiEngineDayDual != null ? log.multiEngineDayDual : 0,
      'MultiEngineDayPilot' : log.multiEngineDayPilot != null ? log.multiEngineDayPilot : 0,
      'MultiEngineNightCopilot' : log.multiEngineNightCopilot != null ? log.multiEngineNightCopilot : 0,
      'MultiEngineNightDual' : log.multiEngineNightDual != null ? log.multiEngineNightDual : 0,
      'MultiEngineNightPilot' : log.multiEngineNightPilot != null ? log.multiEngineNightPilot : 0,
      'Position' : log.position != null ? log.position : "",
      'Route' : log.route != null ? log.route : "",
      'SingleEngineDayDual' : log.singleEngineDayDual != null ? log.singleEngineDayDual : 0,
      'SingleEngineDayPilot' : log.singleEngineDayPilot != null ? log.singleEngineDayPilot : 0,
      'SingleEngineNightDual' : log.singleEngineNightDual != null ? log.singleEngineNightDual : 0,
      'SingleEngineNightPilot' : log.singleEngineNightPilot != null ? log.singleEngineNightPilot : 0,
      'ToCode' : log.toCode != null ? log.toCode : "",
      'TotalHours' : checkNull(log.singleEngineDayDual) + checkNull(log.singleEngineDayPilot) + checkNull(log.singleEngineNightDual) + checkNull(log.singleEngineNightPilot) + checkNull(log.multiEngineDayCopilot) + checkNull(log.multiEngineDayDual) + checkNull(log.multiEngineDayPilot) + checkNull(log.multiEngineNightCopilot) + checkNull(log.multiEngineNightDual) + checkNull(log.multiEngineNightPilot)
    });
  }

}

final DataService dataService = DataService();