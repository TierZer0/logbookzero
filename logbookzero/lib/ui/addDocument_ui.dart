import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/doc_model.dart';
import '../utils/action_button.dart';
import '../services/data.dart';
import '../services/auth.dart';
class AddDocumentView extends StatefulWidget {

  @override
  AddDocumentViewState createState() => AddDocumentViewState();
}

class AddDocumentViewState extends State<AddDocumentView> {
  Document doc = new Document();
  var flightDocs = [];
  List<DropdownMenuItem<String>> _dropDownMenuItems = [];
  String _currentDoc;
  String userID;
  @override
  void initState() {
    super.initState();
    
    userID = authService.currentUser;
    createList();
    dateController.text = null;
  }

  void createList() async {
    Firestore.instance.collection('flightDocuments').snapshots().listen((data) => data.documents.forEach((doc) {
      _dropDownMenuItems.add(
        new DropdownMenuItem(
          value: doc['Document'],
          child: new Text(
            doc['Document']
          ),
        )
      );
    }));

  }
  

  final dateController = new TextEditingController();
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
        //streamQuery = Firestore.instance.collection('users').document(userID).collection('logbook').where('FlightDate', isGreaterThan: _selectedDate).snapshots();
      });
    }
  }

  final _darkText = new Color(0xFF263238);
  final _teal = new Color(0xFF00bcd4);
  double whiteHeight = 0.75;
  int _duration = 1000;
  bool isActive = false;
  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: <Widget>[
        new Container(
          alignment: Alignment.bottomCenter,
          height: MediaQuery.of(context).size.height,
          color: _teal,
          child: new Container(
            margin: EdgeInsets.only(
              bottom: Platform.isIOS ? 15 : 0
            ),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                new AnimatedOpacity(
                  opacity: isActive == false ? 0 : 1,
                  duration: Duration(milliseconds: _duration),
                  child: new Card(
                    margin: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10
                    ),
                    elevation: 6,
                    child: new Padding(
                      padding: EdgeInsets.all(5),
                      child: new StreamBuilder(
                        stream: Firestore.instance.collection('users').document(userID).collection('flightDocuments').snapshots(),
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.data == null) {
                            return new Center(
                              child: new CircularProgressIndicator()
                            );
                          } else if (snapshot.hasError) {
                            return new Center(
                              child: new Text(
                                "An Error Has Occured When Loading Data"
                              )
                            );
                          } else if (snapshot.data != null) {
                            return new ListView(
                              shrinkWrap: true,
                              padding: EdgeInsets.only(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                top: 0
                              ),
                              children: snapshot.data.documents.map((DocumentSnapshot doc) {
                                return isActive == true ? new Container(
                                  margin: EdgeInsets.symmetric(
                                    vertical: 5
                                  ),
                                  decoration: new BoxDecoration(
                                    border: new Border.all(
                                      color: Colors.black45,
                                      width: 1,
                                      style: BorderStyle.solid
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5)
                                    ),
                                  ),
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      new Text(
                                        //"test",
                                        doc['DocName'] + " - " + DateFormat.yMMMd().format(doc['DateIssued']),
                                        style: new TextStyle(
                                          fontSize: 18
                                        )
                                      ),
                                      new IconButton(
                                        icon: Icon(Icons.close),
                                        onPressed: () {
                                          dataService.removeDocument(doc);
                                        },
                                      )
                                    ],
                                  )
                                ) : SizedBox(
                                  height: 0,
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
                  text: isActive == false ? "View Existing Documents" : "Hide Existing Documents",
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
          )
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
            ],
          ),
          padding: EdgeInsets.only(
            bottom: 2,
            left: 20,
            right: 20
          ),
          child: new Container(
            height: 100,
            padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10
            ),
            margin: EdgeInsets.only(
              top: 10,
              bottom: MediaQuery.of(context).size.height * .35
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10)
              ),
              boxShadow: [
                new BoxShadow(
                  blurRadius: 10,
                  color: Colors.black45
                )
              ],
              color: Colors.white
            ),
            child: new ListView(
              shrinkWrap: false,
              children: <Widget>[
                new Align(
                  alignment: Alignment.center,
                  child: new Text(
                    "Add New Flight Document",
                    style: new TextStyle(
                      color: _darkText,
                      fontSize: 20,
                      fontWeight: FontWeight.w400
                    ),
                  ),
                ),
                new Padding(
                  padding: EdgeInsets.only(
                    top: 20
                  ),
                  child: new TextField(
                    decoration: new InputDecoration(
                      labelText: "Select Date",
                      labelStyle: new TextStyle(
                        fontSize: 15
                      ),
                      hasFloatingPlaceholder: true,
                      border: new OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        borderSide: new BorderSide(
                          color: Colors.black54
                        )
                      )
                    ),
                    onTap: () => _selectDate(context),
                    controller: dateController,
                  ),
                ),
                new Padding(
                  padding: EdgeInsets.only(
                    top: 15,
                    left: 5,
                    right: 5
                  ),
                  child: new DropdownButton(
                    value: _currentDoc,
                    items: _dropDownMenuItems,
                    onChanged: (String selected) => _dropDownChange(selected),
                    hint: new Text(
                      "Select Document"
                    ),
                    isExpanded: true,
                    style: new TextStyle(
                      fontSize: 17,
                      color: _darkText
                    ),
                  ),
                ),
                new Padding(
                  padding: EdgeInsets.only(
                    top: 25
                  ),
                  child: new MaterialButton(
                    child: new Text(
                      "Upload Document",
                      style: new TextStyle(
                        fontSize: 18
                      ),
                    ),
                    padding: EdgeInsets.all(10),
                    disabledTextColor: Colors.grey,
                    onPressed: (_currentDoc == null && dateController.text == "") ? null : () {
                      doc.docName = _currentDoc;
                      _currentDoc = null;
                      doc.dateIssued = _selectedDate;
                      dateController.clear();
                      var renewalPeriod = dataService.getDocumentInfo(_currentDoc);
                      print(renewalPeriod);
                      
                      //doc.dateRenew = 

                      //dataService.addNewFlightDocument(doc);

                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return new Material(
                            elevation: 10,
                            color: Colors.greenAccent,
                            child: new Container(
                              height: 200,
                              width: MediaQuery.of(context).size.width,
                              child: new Center(
                                child: new Text(
                                  "Document Uploaded Sucessfully",
                                  style: new TextStyle(
                                    color: _darkText,
                                    fontSize: 22
                                  )
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
        )
      ],
    );
  }

  void _dropDownChange(String selected) {
    setState(() {
      _currentDoc = selected;
    });
  }
}