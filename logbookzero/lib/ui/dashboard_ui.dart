import 'dart:async';

import 'package:flutter/material.dart';
import '../services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../utils/action_button.dart';
import '../ui/detail_ui.dart';

class DashboardView extends StatefulWidget {
  @override
  DashboardViewState createState() => DashboardViewState();
}

class DashboardViewState extends State<DashboardView> {
  String userID;
  Stream<QuerySnapshot> streamQuery;
  
  Firestore firestore = Firestore();
  @override
  initState() {
    super.initState();

    
    //initFirestore();
    this.isActive = false;
    this.userID = authService.currentUser;
    streamQuery = Firestore.instance.collection('users').document(userID).collection('logbook').orderBy('FlightDate', descending: true).limit(15).snapshots();
  }
  
  void initFirestore() async {
    await firestore.settings(timestampsInSnapshotsEnabled: true);
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

  final _darkText = new Color(0xFF263238);
  final _teal = new Color(0xFF00bcd4);
  double whiteHeight = 0.75;
  bool isActive = false;
  int _duration = 750;
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
          margin: EdgeInsets.only(
            top: 0,
          ),
          child: new Container(
            margin: EdgeInsets.only(
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
                              fontSize: 20
                            ) 
                          ),
                          new SizedBox(
                            height: 10
                          ),
                          new Padding(
                            padding: EdgeInsets.all(10),
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
                            ),
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
                                    color: _darkText
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
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ),
                new ActionButton(
                  icon: isActive == false ? Icons.arrow_upward : Icons.arrow_downward,
                  text: isActive == false ? "Filter Dashboard" : "View Dashboard",
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
        ),
        new AnimatedContainer(
          duration: Duration(milliseconds: _duration),
          height: MediaQuery.of(context).size.height * whiteHeight,
          decoration: new BoxDecoration(
            color: Colors.white,
            boxShadow: [
              new BoxShadow(
                color: Colors.black45,
                blurRadius: 15
              )
            ],
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(60)
            )
          ),
          padding: EdgeInsets.only(
            bottom: 12,
            top: 0,
            left: 5,
            right: 5
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
                    "An Error Has Ocurred",
                    style: new TextStyle(
                      color: Colors.redAccent
                    ),
                  ),
                );
              } else if (snapshot.data != null) {
                return new Container(
                  color: Colors.transparent,
                  child: new ListView(
                    shrinkWrap: false,
                    padding: EdgeInsets.only(
                      bottom: 30,
                      left: 21,
                      right: 21
                    ),
                    children: snapshot.data.documents.map((DocumentSnapshot log) {
                      return new Container(
                        decoration: new BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10)
                          ),
                          boxShadow: [
                            new BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8
                            ),
                          ],
                        ),
                        margin: EdgeInsets.symmetric(
                          vertical: 10
                        ),
                        child: new Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              10
                            ),
                          ),
                          child: new InkWell(
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                10
                              ),
                            ),
                            child: new Container(
                              padding: EdgeInsets.all(10),
                              child: new Column(
                                children: <Widget>[
                                  new Text(
                                    log['AircraftType'] == null ? "" : log['AircraftType'],
                                    style: new TextStyle(
                                      fontSize: 20,
                                      color: _teal
                                    ),
                                  ),
                                  new Text(
                                    log['FlightDate'] == null ? "" : DateFormat.yMMMd().format(log['FlightDate']).toString(),
                                    style: new TextStyle(
                                      fontSize: 17
                                    ),
                                  ),
                                  new Text(
                                    log['FromCode'] == null ? "" : log['FromCode'] + " To " + log['ToCode'],
                                    style: new TextStyle(
                                      fontSize: 17
                                    )
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context, 
                                MaterialPageRoute(
                                  builder: (context) => new DetailView(log: log),
                                )
                              );
                            },
                          ),
                        ),
                      );
                    }).toList(),
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