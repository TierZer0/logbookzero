import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'dart:io';

import '../services/auth.dart';
import '../utils/action_button.dart';
class LogbookView extends StatefulWidget {

  @override
  LogbookViewState createState() => LogbookViewState();
}

List<DataRow> _createRows(QuerySnapshot snapshot) {
  List<DataRow> newList = snapshot.documents.map((DocumentSnapshot doc) {
    return new DataRow(
      cells: <DataCell> [
        new DataCell(
          new Text(
            DateFormat.yMMMd().format(doc['FlightDate']).toString()
          )
        ),
        new DataCell(
          new Text(
            doc['AircraftType']
          )
        ),
        new DataCell(
          new Text(
            doc['AircraftRegistration']
          )
        ),
        new DataCell(
          new Text(
            doc['FromCode']
          )
        ),
        new DataCell(
          new Text(
            doc['ToCode']
          )
        ),
        new DataCell(
          new Text(
            doc['Position']
          )
        ),
        new DataCell(
          new Text(
            doc['SingleEngineDayPilot'].toString()
          )
        ),
        new DataCell(
          new Text(
            doc['SingleEngineDayDual'].toString()
          )
        ),
        new DataCell(
          new Text(
            doc['SingleEngineNightPilot'].toString()
          )
        ),
        new DataCell(
          new Text(
            doc['SingleEngineNightDual'].toString()
          )
        ),
        new DataCell(
          new Text(
            doc['MultiEngineDayPilot'].toString()
          )
        ),
        new DataCell(
          new Text(
            doc['MultiEngineDayDual'].toString()
          )
        ),
        new DataCell(
          new Text(
            doc['MultiEngineDayCopilot'].toString()
          )
        ),
        new DataCell(
          new Text(
            doc['MultiEngineNightPilot'].toString()
          )
        ),
        new DataCell(
          new Text(
            doc['MultiEngineNightDual'].toString()
          )
        ),
        new DataCell(
          new Text(
            doc['MultiEngineNightCopilot'].toString()
          )
        ),
        new DataCell(
          new Text(
            doc['CrossCountryDayPilot'].toString()
          )
        ),
        new DataCell(
          new Text(
            doc['CrossCountryDayDual'].toString()
          )
        ),
        new DataCell(
          new Text(
            doc['CrossCountryNightPilot'].toString()
          )
        ),
        new DataCell(
          new Text(
            doc['CrossCountryNightDual'].toString()
          )
        ),
        new DataCell(
          new Text(
            doc['IntrumentCloud'].toString()
          )
        ),
        new DataCell(
          new Text(
            doc['InstrumentSim'].toString()
          )
        ),
        new DataCell(
          new Text(
            doc['InstrumentHood'].toString()
          )
        ),
        new DataCell(
          new Text(
            doc['FlightNotes']
          )
        )
      ]
    );
  }).toList();

  return newList;
}

List<String> columnList = <String>[
  "Flight Date",
  "Aircraft",
  "Registration",
  "Origin",
  "Destination",
  "Position",
  "Single Engine Day Pilot",
  "Single Engine Day Dual",
  "Single Engine Night Pilot",
  "Single Engine Night Dual",
  "Multi Engine Day Pilot",
  "Multi Engine Day Dual",
  "Multi Engine Day Copilot",
  "Multi Engine Night Pilot",
  "Multi Engine Night Dual",
  "Multi Engine Night Copilot",
  "Cross Country Day Pilot",
  "Cross Country Day Dual",
  "Cross Country Night Pilot",
  "Cross Country Night Dual",
  "Instruent Cloud",
  "Instrunment Sim",
  "Instrument Coud",
  "Flight Notes"
];

List<DataColumn> _createColumns() {
  List<DataColumn> newList = columnList.map((title) {
    return new DataColumn(
      label: new Text(
        title
      )
    );
  }).toList();

  return newList;
}



class LogbookViewState extends State<LogbookView> {
  int _duration = 750;
  final _darkText = new Color(0xFF263238);
  final _teal = new Color(0xFF00bcd4);
  bool isActive = false;
  double whiteHeight = 0.75;  
  String userID;  
  Stream<QuerySnapshot> streamQuery;
  @override
  void initState() {
    super.initState();
    this.userID = authService.currentUser;
    streamQuery = Firestore.instance.collection('users').document(userID).collection('logbook').limit(15).snapshots();
  }

  final dateController = new TextEditingController();
  final aircraftTypeController = new TextEditingController();
  final regController = new TextEditingController();
  DateTime _selectedDate = DateTime.now().subtract(new Duration(days: 5));
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2010, 8),
      lastDate: DateTime.now()
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        dateController.text =  DateFormat.yMMMd().format(_selectedDate).toString();
        streamQuery = Firestore.instance.collection('users').document(userID).collection('logbook').where('FlightDate', isGreaterThan: _selectedDate).snapshots();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: <Widget>[
        new AnimatedContainer(
          duration: Duration(milliseconds: _duration),
          alignment: Alignment.bottomCenter,
          height: MediaQuery.of(context).size.height,
          decoration: new BoxDecoration(
            color: _teal
          ),
          margin: EdgeInsets.all(0),
          padding: EdgeInsets.only(
            bottom: Platform.isIOS ? 15 : 0
          ),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              new AnimatedOpacity(
                opacity: isActive == false ? 0 : 1,
                duration: Duration(milliseconds: _duration),
                child: new Card(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  elevation: 5,
                  child: new Padding(
                    padding: EdgeInsets.all(15),
                    child: new Column(
                      children: <Widget>[
                        new Text(
                          "Choose One Of The Filters Below",
                          style: new TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400
                          )
                        ),
                        new SizedBox(
                          height: 20,
                        ),
                        new Padding(
                          padding:EdgeInsets.all(10),
                          child: new TextField(
                            decoration: new InputDecoration(
                              labelText: "Choose Start Date",
                              labelStyle: new TextStyle(
                                fontSize: 15
                              ),
                              hasFloatingPlaceholder: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                  color: _darkText
                                )
                              )
                            ),
                            style: new TextStyle(
                              fontSize: 15
                            ),
                            controller: dateController,
                            onTap: () => _selectDate(context),
                          )
                        ),
                        new Padding(
                          padding: EdgeInsets.all(10),
                          child: new TextField(
                            decoration: new InputDecoration(
                              labelText: "Choose Aircraft Type",
                              labelStyle: new TextStyle(
                                fontSize: 15
                              ),
                              hasFloatingPlaceholder: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                  color: _darkText
                                )
                              )
                            ),
                            style: new TextStyle(
                              fontSize: 15
                            ),
                            controller: aircraftTypeController,
                            onEditingComplete: () {
                              setState(() {
                                streamQuery = Firestore.instance.collection('users').document(userID).collection('logbook').where('AircraftType', isEqualTo: aircraftTypeController.text).snapshots();
                              });
                            },
                          ),
                        ),
                        new Padding(
                          padding: EdgeInsets.all(10),
                          child: new TextField(
                            decoration: new InputDecoration(
                              labelText: "Choose Aircraft Registration",
                              labelStyle: new TextStyle(
                                fontSize: 15
                              ),
                              hasFloatingPlaceholder: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                  color:_darkText
                                )
                              )
                            ),
                            style: new TextStyle(
                              fontSize: 15
                            ),
                            controller: regController,
                            onEditingComplete: () {
                              setState(() {
                                streamQuery = Firestore.instance.collection('users').document(userID).collection('logbook').where('AircraftRegistration', isEqualTo: regController.text).snapshots();
                              });
                            },
                          )
                        )
                      ],
                    ),
                  )
                ),
              ),
              new ActionButton(
                icon: isActive == false ? Icons.arrow_upward : Icons.arrow_downward,
                text: isActive == false ? "Filter Logbook" : "View Logbook",
                onTap: () => isActive == false ? setState(() {
                  isActive = true;
                  whiteHeight = 0.15;
                }) : setState(() {
                  isActive = false;
                  whiteHeight = 0.75;
                }),
              )
            ],
          ),
        ),
        new AnimatedContainer(
          duration: Duration(milliseconds: _duration),
          height: MediaQuery.of(context).size.height * whiteHeight,
          decoration: new BoxDecoration(
            color: Colors.white,
            boxShadow: [
              new BoxShadow(
                color: _darkText,
                blurRadius: 15
              )
            ],
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(60)
            )
          ),
          padding: EdgeInsets.only(
            bottom: 12
          ),
          child: new StreamBuilder(
            stream: streamQuery,
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.data == null) {
                return new Center(
                  child: new CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return new Center(
                  child: new Text(
                    "An Error Has Occured"
                  ),
                );
              } else if (snapshot.data != null) {
                return new Container(
                  padding: EdgeInsets.all(20),
                  child: new Material(
                    elevation: 5,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Colors.white,
                    child: new SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: new DataTable(
                        columns: _createColumns(),
                        rows: _createRows(snapshot.data),
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}