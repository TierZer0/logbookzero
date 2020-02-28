import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class DetailView extends StatefulWidget {

  final DocumentSnapshot log;

  DetailView({this.log});

  @override
  DetailViewState createState() => DetailViewState(log: log);
}

class DetailViewState extends State<DetailView> {

  final String key = "AIzaSyBuVmi-r1FWjcDN231CgCgZADNJ4bn0K_c";
  final String iosKey = "AIzaSyBNqTyDDRsF2rLdTfVapM6aZiQHXoAylJ0";
  final String androidKey = "AIzaSyDUGwCRMhGtma5msf_BzmyF6GBORmw702c";

  final DocumentSnapshot log;
  String fullUrl;
  DetailViewState({this.log});
  var url;
  var ref;
  @override
  initState() {
    super.initState();
    createImage();
    getUrl();
    
  }

  @override
  void dispose() {
    super.dispose();
  }

  getUrl() async {
    
    try {
      //var test = Firestore.instance.collection('aircraft').document('information').collection('Cessna-172').snapshots();
      var ref = FirebaseStorage.instance.ref().child('aircraft').child(log['AircraftType']+".jpg");
      //print(ref);

      var temp = await ref.getDownloadURL();

      setState(() {
        url = temp;
      });
    } catch(e) {

    }
    
  }

  createImage() async {
    var baseUrl = "https://maps.googleapis.com/maps/api/staticmap?&size=600x400";
    var markers = "&markers=color:blue|label:O|" + log['FromCode'] + "&markers=color:blue|label:D|" + log['ToCode'];
    var path = "&path=color:blue|weight:5|" + log['FromCode'] + "|" + log['ToCode'];
    var key = "&key=" + (Platform.isIOS == true ? iosKey : androidKey);
    fullUrl = baseUrl + markers + path + key;
    //print(fullUrl);
  }


  final _darkText = new Color(0xFF263238);
  final _teal = new Color(0xFF00bcd4);
  final double whiteHeight = 0.75;
  final bool isActive = false;
  final int _duration = 750;
  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: new Scaffold(
        appBar: new AppBar(
          backgroundColor: _teal,
          elevation: 3,
          centerTitle: true,
          title: new Text(
            log['AircraftRegistration'],
            style: new TextStyle(
              fontSize: 25
            ),
          ),
          bottom: new PreferredSize(
            preferredSize: Size(20, 10),
            child: new Text(
              DateFormat.yMMMd().format(log['FlightDate']).toString(),
              style: new TextStyle(
                color: Colors.white,
                fontSize: 17
              ),
            ),
          ),
        ),
        body: new Stack(
          children: <Widget>[
            new Container(
              color: _teal,
              height: MediaQuery.of(context).size.height
            ),
            new AnimatedContainer(
              duration: Duration(milliseconds: _duration),
              height: MediaQuery.of(context).size.height * whiteHeight,
              width: MediaQuery.of(context).size.width,
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(60)
                ),
                boxShadow: [
                  new BoxShadow(
                    blurRadius: 10,
                    color: Colors.black45
                  )
                ]
              ),
              child: new AnimatedContainer(
                duration: Duration(milliseconds: 750),
                padding: EdgeInsets.only(
                  left: 0,
                  right: 0
                ),
                margin: EdgeInsets.only(
                  top: 20,
                  bottom: 50,
                  left: 20,
                  right: 20
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    new BoxShadow(
                      blurRadius: 5,
                      color:Colors.black45
                    ),
                  ],
                  borderRadius: BorderRadius.all(
                    Radius.circular(20)
                  ),
                ),
                child: new Stack(
                  children: <Widget>[
                    url == null ? new SizedBox(
                      height: 0
                    ) : new ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)
                      ),
                      child: new Image.network(
                        url,
                        fit: BoxFit.fitWidth,
                        height: 175,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                    new Container(
                      height: 175,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)
                        ),
                      ),
                    ),
                    new Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        new SizedBox(
                          height: 172,
                        ),
                        new Text(
                          log['AircraftType'],
                          style: new TextStyle(
                            fontSize: 25,
                            color: _darkText
                          ),
                          textAlign: TextAlign.center,
                        ),
                        new Text(
                          log['FromCode'] + " To " + log['ToCode'],
                          style: new TextStyle(
                            fontSize: 19,
                            color: _darkText
                          ),
                          textAlign: TextAlign.center,
                        ),
                        new Text(
                          log['Route'] == null ? "" : log['Route'],
                          style: new TextStyle(
                            fontSize: 15,
                            color: _darkText
                          ),
                          textAlign: TextAlign.center,
                        ),
                        new Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 10
                          ),
                          child:  new Image.network(
                            fullUrl,
                          ),
                        ),
                        new Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new Text(
                              "Single Engine Hours: " + (log['SingleEngineDayPilot'] + log['SingleEngineDayDual'] + log['SingleEngineNightPilot'] + log['SingleEngineNightDual']).toString(),
                              style: new TextStyle(
                                fontSize: 15,
                                color: _darkText
                              ),
                            ),
                            new Text(
                              "Multi Engine Hours: " + (log['MultiEngineDayPilot'] + log['MultiEngineDayDual'] + log['MultiEngineDayCopilot'] +  log['MultiEngineNightPilot'] + log['MultiEngineNightDual'] + log['MultiEngineNightCopilot']).toString(),
                              style: new TextStyle(
                                fontSize: 15,
                                color: _darkText
                              ),
                            ),
                            new Text(
                              "Cross Country Hours: " + (log['CrossCountryDayPilot'] + log['CrossCountryDayDual'] + log['CrossCountryNightPilot'] + log['CrossCountryNightDual']).toString(),
                              style: new TextStyle(
                                fontSize: 15
                              ),
                            ),
                            new Text(
                              "Instrument Hours: " + (log['InstrumentSim'] + log['InstrumentCloud'] +log['InstrumentHood']).toString(),
                              style: new TextStyle(
                                fontSize: 15,
                                color: _darkText
                              ),
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}