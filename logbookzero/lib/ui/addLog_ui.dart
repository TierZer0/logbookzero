import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../utils/action_button.dart';

import '../utils/item_container.dart';
import '../utils/input_field.dart';
import '../utils/title_text.dart';

import '../services/auth.dart';
import '../services/data.dart';

import '../models/log_model.dart';
class AddLogView extends StatefulWidget {

  @override
  AddLogViewState createState() => AddLogViewState();
}


class AddLogViewState extends State<AddLogView> {
  
  String userID;
  FlightLog log = new FlightLog();

  //final _darkText = new Color(0xFF263238);
  final _teal = new Color(0xFF00bcd4);
  double whiteHeight = 0.75;
  int _duration = 750;
  bool isActive = false;


  int currentPage = 0;
  @override
  void initState() {
    super.initState();
    userID = authService.currentUser;

    ctrl.addListener(() { 
      int next = ctrl.page.round();

      if(currentPage != next) { 
        setState(() {
          currentPage = next;
          //print(currentPage);
        });
      } 
    });


  }

  final dateController = new TextEditingController();
  final aircraftType = new TextEditingController();
  final aircraftReg = new TextEditingController();
  final position = new TextEditingController();
  final from = new TextEditingController();
  final to = new TextEditingController();
  final route = new TextEditingController();

  final singlePilotDay = new TextEditingController();
  final singleDualDay = new TextEditingController();
  final singlePilotNight = new TextEditingController();
  final singleDualNight = new TextEditingController();

  final multiPilotDay =  new TextEditingController();
  final multiDualDay = new TextEditingController();
  final multiCopilotDay = new TextEditingController();
  final multiPilotNight = new TextEditingController();
  final multiDualNight = new TextEditingController();
  final mutliCopilotNight = new TextEditingController();

  final crossPilotDay = new TextEditingController();
  final crossDualDay =  new TextEditingController();
  final crossPilotNight = new TextEditingController();
  final crossDualNight = new TextEditingController();

  final hood = new TextEditingController();
  final cloud = new TextEditingController();
  final sim = new TextEditingController();

  final notes = new TextEditingController();
  DateTime _selectedDate = DateTime.now().subtract(new Duration(days: 5));
  void _selectDate(BuildContext context) async {
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
        //streamQuery = Firestore.instance.collection('users').document(userID).collection('logbook').where('FlightDate', isGreaterThan: _selectedDate).snapshots();
      });
    }
  }




  final PageController ctrl = PageController(
    viewportFraction: 0.8
  );

  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: <Widget>[
        new Container(
          alignment: Alignment.bottomCenter,
          color: _teal,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: new Container(
            margin: EdgeInsets.only(
              bottom: Platform.isIOS ? 15 : 0 
            ),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                new AnimatedOpacity(
                  opacity: isActive == false ? 0 : 1,
                  duration: Duration(milliseconds: 300),
                  child: new Container(
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20)
                      ),
                      boxShadow: [
                        new BoxShadow(
                          blurRadius: 12,
                          color: Colors.black54
                        )
                      ]
                    ),
                    height: MediaQuery.of(context).size.height * .5,
                    margin: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10
                    ),
                    child: new Padding(
                      padding: EdgeInsets.all(10),
                      child: new StreamBuilder(
                        stream: Firestore.instance.collection('users').document(userID).collection('logbook').snapshots(),
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
                            return new ListView(
                              shrinkWrap: true,
                              children: snapshot.data.documents.map((DocumentSnapshot log) {
                                return new Container(
                                  margin: EdgeInsets.symmetric(
                                    vertical: 5
                                  ),
                                  decoration: new BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5)
                                    ),
                                    border: new Border.all(
                                      color: Colors.black45,
                                      width: 1,
                                      style: BorderStyle.solid
                                    )
                                  ),
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      new Text(
                                        DateFormat.yMMMd().format(log['FlightDate']) + " - " + log['AircraftType'],
                                        style: new TextStyle(
                                          fontSize: 18
                                        ),
                                      ),
                                      new IconButton(
                                        icon: Icon(Icons.close),
                                        onPressed: () {
                                          dataService.removeLog(log);
                                        },
                                      )
                                    ],
                                  ),
                                );
                              }).toList(),
                            );
                          }
                        }, 
                      ),
                    ),
                  ),
                ),
                new ActionButton(
                  icon: isActive == false ? Icons.arrow_upward : Icons.arrow_downward,
                  text: isActive == false ? "View Existing Flight Logs" : "Hide Existing Flight Logs",
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
          width: MediaQuery.of(context).size.width,
          decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(60)
            ),
            boxShadow: [
              new BoxShadow(
                color: Colors.black45,
                blurRadius: 15
              )
            ]
          ),
          padding: EdgeInsets.only(
            top: 0,
            bottom: 60,
            left: 0,
            right: 0
          ),
          child: new PageView(
            controller: ctrl,
            children: <Widget>[
              new ItemContainer(
                content: new ListView(
                  shrinkWrap: false,
                  children: <Widget>[
                    new TitleText(
                      text: "Flight Information",
                      size: 20
                    ),
                    new SizedBox(
                      height: 10,
                    ),
                    Platform.isIOS == true ? new CupertinoButton(
                      child: new Text(
                        "Select Flight Date"
                      ),
                      onPressed: () => _selectDate(context),
                    ) : new InputField(
                      controller: dateController,
                      label: "Select Flight Date",
                      type: TextInputType.datetime,
                      onTap: () => _selectDate(context),
                    ),
                    new InputField(
                      controller: aircraftType,
                      label: "Enter Aircraft Type",
                      type: TextInputType.text,
                      onTap: () => {},
                    ),
                    new InputField(
                      controller: aircraftReg,
                      label: "Enter Aircraft Registration",
                      type: TextInputType.text,
                      onTap: () => {},
                    ),
                    new InputField(
                      controller: position,
                      label: "Enter Flight Position",
                      type: TextInputType.text,
                      onTap: () => {},
                    ),
                    new InputField(
                      controller: from,
                      label: "Enter Origin Airport",
                      type: TextInputType.text,
                      onTap: () => {},
                    ),
                    new InputField(
                      controller: to,
                      label: "Enter Destination Airport",
                      type: TextInputType.text,
                      onTap: () => {},
                    ),
                    new InputField(
                      controller: route,
                      label: "Enter Flight Route",
                      type: TextInputType.text,
                      onTap: () => {},
                    )
                  ],
                ),
              ),
              new ItemContainer(
                content: new ListView(
                  shrinkWrap: false,
                  children: <Widget>[
                    new TitleText(
                      text: "Single Engine Hours",
                      size: 20,
                    ),
                    new SizedBox(
                      height: 10,
                    ),
                    new InputField(
                      controller: singlePilotDay,
                      label: "Pilot Day Hours",
                      type: TextInputType.number,
                      onTap: () => {}
                    ),
                    new InputField(
                      controller: singleDualDay,
                      label: "Dual Day Hours",
                      type: TextInputType.number,
                      onTap: () => {},
                    ),
                    new InputField(
                      controller: singlePilotNight,
                      label: "Pilot Night Hours",
                      type: TextInputType.number,
                      onTap: () => {},
                    ),
                    new InputField(
                      controller: singleDualNight,
                      label: "Dual Night Hours",
                      type: TextInputType.number,
                      onTap: () => {},
                    )
                  ],
                ),
              ),
              new ItemContainer(
                content: new ListView(
                  shrinkWrap: false,
                  children: <Widget>[
                    new TitleText(
                      text: "Multi Engine Hours",
                      size: 20,
                    ),
                    new SizedBox(
                      height: 10,
                    ),
                    new InputField(
                      controller: multiPilotDay,
                      label: "Pilot Day Hours",
                      type: TextInputType.number,
                      onTap: () => {},
                    ),
                    new InputField(
                      controller: multiDualDay,
                      label: "Dual Day Hours",
                      type: TextInputType.number,
                      onTap: () => {},
                    ),
                    new InputField(
                      controller: multiCopilotDay,
                      label: "Copilot Day Hours",
                      type: TextInputType.number,
                      onTap: () => {},
                    ),
                    new InputField(
                      controller: multiPilotNight,
                      label: "Pilot Night Hours",
                      type: TextInputType.number,
                      onTap: () => {},
                    ),
                    new InputField(
                      controller: multiDualNight,
                      label: "Dual Night Hours",
                      type: TextInputType.number,
                      onTap: () => {},
                    ),
                    new InputField(
                      controller: mutliCopilotNight,
                      label: "Copilot Night Hours",
                      type: TextInputType.number,
                      onTap: () => {},
                    )
                  ],
                )
              ),
              new ItemContainer(
                content: new ListView(
                  shrinkWrap: false,
                  children: <Widget>[
                    new TitleText(
                      text: "Cross Country Hours",
                      size: 20,
                    ),
                    new SizedBox(
                      height: 10
                    ),
                    new InputField(
                      controller: crossPilotDay,
                      label: "Pilot Day Hours",
                      type: TextInputType.number,
                      onTap: () => {},
                    ),
                    new InputField(
                      controller: crossDualDay,
                      label: "Dual Day Hours",
                      type: TextInputType.number,
                      onTap: () => {},
                    ),
                    new InputField(
                      controller: crossPilotNight,
                      label: "Pilot Night Hours",
                      type: TextInputType.number,
                      onTap: () => {},
                    ),
                    new InputField(
                      controller: crossDualNight,
                      label: "Dual Night Hours",
                      type: TextInputType.number,
                      onTap: () => {},
                    )
                  ],
                ),
              ),
              new ItemContainer(
                content: new ListView(
                  shrinkWrap: false,
                  children: <Widget>[
                    new TitleText(
                      text: "Instrument Hours",
                      size: 20,
                    ),
                    new SizedBox(
                      height: 10
                    ),
                    new InputField(
                      controller: hood,
                      label: "Hood Hours",
                      type: TextInputType.number,
                      onTap: () => {},
                    ),
                    new InputField(
                      controller: cloud,
                      label: "Cloud Hours",
                      type: TextInputType.number,
                      onTap: () => {},
                    ),
                    new InputField(
                      controller: sim,
                      label: "Sim Hours",
                      type: TextInputType.number,
                      onTap: () => {},
                    )
                  ],
                ),
              ),
              new ItemContainer(
                content: new ListView(
                  shrinkWrap: false,
                  children: <Widget>[
                    new TitleText(
                      text: "Additional Information",
                      size: 20,
                    ),
                    new SizedBox(
                      height: 10,
                    ),
                    new InputField(
                      controller: notes,
                      label: "Flight Notes",
                      type: TextInputType.text,
                      onTap: () => {},
                    ),
                    new Align(
                      alignment: Alignment.bottomCenter,
                      child: new MaterialButton(
                        child: new Text(
                          "Upload Flight Log",
                          style: new TextStyle(
                            fontSize: 18
                          ),
                        ),
                        padding: EdgeInsets.all(10),
                        onPressed: () {
                          log.aircraftType = aircraftType.text;
                          aircraftType.clear();
                          log.aircraftRegistration = aircraftReg.text;
                          aircraftReg.clear();
                          log.flightDate = _selectedDate;
                          dateController.clear();
                          log.position = position.text;
                          position.clear();
                          log.fromCode = from.text;
                          from.clear();
                          log.toCode = to.text;
                          to.clear();
                          log.route = route.text;
                          route.clear();
                          log.singleEngineDayPilot = int.tryParse(singlePilotDay.text);
                          singlePilotDay.clear();
                          log.singleEngineDayDual = int.tryParse(singleDualDay.text);
                          singleDualDay.clear();
                          log.singleEngineNightPilot = int.tryParse(singlePilotNight.text);
                          singlePilotNight.clear();
                          log.singleEngineNightDual = int.tryParse(singleDualNight.text);
                          singleDualNight.clear();
                          log.multiEngineDayPilot = int.tryParse(multiPilotDay.text);
                          multiPilotDay.clear();
                          log.multiEngineDayDual = int.tryParse(multiDualDay.text);
                          multiDualDay.clear();
                          log.multiEngineDayCopilot = int.tryParse(multiCopilotDay.text);
                          multiCopilotDay.clear();
                          log.multiEngineNightPilot = int.tryParse(multiPilotNight.text);
                          multiPilotNight.clear();
                          log.multiEngineNightDual = int.tryParse(multiDualNight.text);
                          multiDualNight.clear();
                          log.multiEngineNightCopilot = int.tryParse(mutliCopilotNight.text);
                          mutliCopilotNight.clear();
                          log.crossCountryDayPilot = int.tryParse(crossPilotDay.text);
                          crossPilotDay.clear();
                          log.crossCountryDayDual = int.tryParse(crossDualDay.text);
                          crossDualDay.clear();
                          log.crossCountryNightPilot = int.tryParse(crossPilotNight.text);
                          crossPilotNight.clear();
                          log.crossCountryNightDual = int.tryParse(crossDualNight.text);
                          crossDualNight.clear();
                          log.instrumentHood = int.tryParse(hood.text);
                          hood.clear();
                          log.instrumentCloud = int.tryParse(cloud.text);
                          cloud.clear();
                          log.instrumentSim = int.tryParse(sim.text);
                          sim.clear();
                          log.flightNotes = notes.text;
                          notes.clear();

                          dataService.addNewFlightLog(log);

                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return new Material(
                                color: new Color(0xFF00c853),
                                child: new Container(
                                  height: 200,
                                  width: MediaQuery.of(context).size.width,
                                  child: new Center(
                                    child: new Text(
                                      "Flight Log Uploaded Successfully",
                                      style: new TextStyle(
                                        color: Colors.black,
                                        fontSize: 20
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                          );
                        },
                      ),
                    )
                  ],
                ),
              )
            ],
          )
        )
      ],
    );
  }
}