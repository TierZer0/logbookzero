import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logbookzero/services/data.dart';
import 'dart:io';

import '../services/auth.dart';

import '../utils/action_button.dart';
class TrackerView extends StatefulWidget {

  @override
  TrackerViewState createState() => TrackerViewState();
}

class FlightDocuments {
  String docName;
  int renewalTime;
}

class TrackerViewState extends State<TrackerView> {

  String userID;
  Stream<QuerySnapshot> streamQuery;
  bool isActive = false;
  var flightDocs = [];
  @override
  void initState() {
    super.initState();
    this.userID = authService.currentUser;  
    streamQuery = Firestore.instance.collection('users').document(userID).collection('flightDocuments').snapshots();

    Firestore.instance.collection('flightDocuments').snapshots().listen((data) => data.documents.forEach((doc) {
      flightDocs.add({
        'docName' : doc['Document'],
        'renewalTime' : doc['Renewal']
      });
    }));
  }

  calculateRenewalDate(DateTime issued, doc) {
    return issued.add(Duration(days: (doc['renewalTime'] * 30).toInt()));
  }

  determineDocumentStatus(DateTime renewal) {
    var diff = renewal.difference(DateTime.now()).inDays;
    //print(diff);
    if (diff >= 60) {
      return "Current";
    } else if (diff < 60 && diff >= 30) {
      return "Nearing Renewal Date";
    } else if (diff < 30 && diff > 0) {
      return "Prepare For Renewal";
    } else if (diff <= 0) {
      return "No Longer Current";
    }
  }

  List<DropdownMenuItem<String>> _dropDownMenuItems = [
    new DropdownMenuItem(
      value: "Current",
      child: new Text(
        "Current"
      )
    ),
    new DropdownMenuItem(
      value: "Nearing Renewal Date",
      child: new Text(
        "Nearing Renewal Date"
      )
    ),
    new DropdownMenuItem(
      value: "Prepare For Renewal",
      child: new Text(
        "Prepare For Renewal"
      ),
    ),
    new DropdownMenuItem(
      value: "No Longer Current",
      child: new Text(
        "No Longer Current"
      ),
    )
  ];

  final _darkText = new Color(0xFF263238);
  final _teal = new Color(0xFF00bcd4);

  final good = new Color(0xFF4CAF50);
  final warning = new Color(0xFFffb300);
  final bad = new Color(0xFFe53935);
  double whiteHeight = 0.75;
  int _duration = 750;

  final docController = new TextEditingController();
  final statusController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: <Widget>[
        new Container(
          alignment: Alignment.bottomCenter,
          height: MediaQuery.of(context).size.height,
          color: _teal,
          margin: EdgeInsets.only(
            top: 0
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
                    margin: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10
                    ),
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
                          new Padding(
                            padding: EdgeInsets.all(10),
                            child: new TextField(
                              decoration: new InputDecoration(
                                labelText: "Choose Document Type",
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
                              controller: docController,
                              onEditingComplete: () {
                                setState(() {
                                  streamQuery = Firestore.instance.collection('users').document(userID).collection('flightDocuments').where('DocName', isEqualTo: docController.text).snapshots();
                                });
                              },
                            )
                          ),
                          new Padding(
                            padding: EdgeInsets.all(10),
                            child: new TextField(
                              decoration: new InputDecoration(
                                labelText: "Choose Status",
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
                              controller: statusController,
                              onEditingComplete: () {
                                setState(() {
                                  
                                });
                              },
                            )
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                new ActionButton(
                  icon: isActive == false ? Icons.arrow_upward : Icons.arrow_downward,
                  text: isActive == false ? "Filter Documents" : "View Documents",
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
                    "An Error Has Occured",
                    style: new TextStyle(
                      color: Colors.red
                    ),
                  ),
                );
              } else if (snapshot.data != null) {
                //print(flightDocs);
                return new ListView(
                  shrinkWrap: false,
                  padding: EdgeInsets.only(
                    bottom: 30,
                    left: 26,
                    right: 26,
                    top: 0
                  ),
                  children: snapshot.data.documents.map((DocumentSnapshot doc) {

                    var renewalDate = calculateRenewalDate(doc['DateIssued'], flightDocs.singleWhere((docs) => docs['docName'] == doc['DocName']));
                    var status = determineDocumentStatus(renewalDate);
                    var cardColor;
                    dataService.addDocStatus(doc, status);


                    if (status == "Current") {
                      cardColor = good;
                    } else if (status == "No Longer Current") {
                      cardColor = bad;
                    } else {
                      cardColor = warning;
                    }
                    return new Opacity(
                      opacity: .85,
                      child: new Container(        
                        decoration: new BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(20)
                          ),
                          boxShadow: [
                            new BoxShadow(
                              color: Colors.black45,
                              blurRadius: 8
                            ),
                          ]
                        ),
                        margin: EdgeInsets.symmetric(
                          vertical: 8
                        ),
                        child: new Container(
                          padding: EdgeInsets.all(15),
                          child: new Column(
                            children: <Widget>[
                              new Text(
                                doc['DocName'],
                                style: new TextStyle(
                                  fontSize: 20,
                                  color: Colors.white
                                ),
                              ),
                              new SizedBox(
                                height: 10
                              ),
                              new Text(
                                "Date Issued: " + DateFormat.yMMMd().format(doc['DateIssued']).toString(),
                                style: new TextStyle(
                                  fontSize: 17,
                                  color: Colors.white
                                )
                              ),
                              new Text(
                                "Renewal Date: " + DateFormat.yMMMd().format(renewalDate).toString(),
                                style: new TextStyle(
                                  fontSize: 17,
                                  color: Colors.white
                                ) 
                              ),
                              new SizedBox(
                                height: 15
                              ),
                              new Text(
                                "Status: " + status,
                                style: new TextStyle(
                                  fontSize: 17,
                                  color: Colors.white
                                ) 
                              )
                            ],
                          ),
                        )
                      ),
                    );
                  }).toList(),
                );
              }
            }
          ),
        )
      ],
    );
  }

}
