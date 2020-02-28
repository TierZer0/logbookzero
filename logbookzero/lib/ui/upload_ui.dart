import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert' as convert;

import '../utils/action_button.dart';
import '../services/data.dart';
class UploadView extends StatefulWidget {

  @override
  UploadViewState createState() => UploadViewState();
}

class UploadViewState extends State<UploadView> {

  File _image;
  String downloadURL;
  String responseText = "Scan Image To See Results";

  getImageFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });

    if (_image != null) {
      dataService.addLogbookImage(_image).then((response) {
        this.downloadURL = response;
        //print(response);
      });
    }
    
  }

  Future getImageFromCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  Future scanImage() async {
    var request = {
      "requests" : [
        {
          "image" : {
            "source" : {
              "imageUri" : this.downloadURL
            }
          },
          "features" : [
            {
              "type" : "DOCUMENT_TEXT_DETECTION"
            }
          ]
        }
      ]
    };

    dataService.scanLogbookImage(convert.jsonEncode(request)).then((response) {
      print(response);
    });
    setState(() {
      _image = null;
    });
    
  }

  final _darkText = new Color(0xFF263238);
  final _teal = new Color(0xFF00bcd4);
  double whiteHeight = 0.75;
  int _duration = 650;
  bool isActive = false;

  List<DropdownMenuItem<String>> _dropDownMenuItems = [];
  String _currentDoc;
  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: <Widget>[
        new Container(
          padding: EdgeInsets.only(
            bottom: 10
          ),
          alignment: Alignment.topCenter,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: _teal,
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              new AnimatedOpacity(
                opacity: isActive == false ? 0 : 1,
                duration: Duration(milliseconds: _duration),
                child: new Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 15
                  ),
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        10
                      )
                    ),
                    boxShadow: [
                      new BoxShadow(
                        color: Colors.black54,
                        blurRadius: 15
                      )
                    ]
                  ),
                  child: new Padding(
                    padding: EdgeInsets.all(
                      15
                    ),
                    child: new Column(
                      children: <Widget>[
                        new Text(
                          "Upload and Scan Image",
                          style: new TextStyle(
                            fontSize: 20
                          ),
                        ),
                        new SizedBox(
                          height: 10
                        ),
                        new DropdownButton(
                          value: _currentDoc,
                          items: _dropDownMenuItems,
                          onChanged: (String selected) => {},
                          hint: new Text(
                            "Select Logbook Template"
                          ),
                          isExpanded: true,
                          style: new TextStyle(
                            fontSize: 17,
                            color: _darkText
                          ),
                        ),
                        new SizedBox(
                          height: 10,
                        ),
                        new Row(
                          children: <Widget>[
                            new Material(
                              color: Colors.white,
                              child: new InkWell(
                                child: new Container(
                                  width: MediaQuery.of(context).size.width * .65,
                                  decoration: new BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black38
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10)
                                    )
                                  ),
                                  padding: EdgeInsets.all(10),
                                  alignment: Alignment.center,
                                  child: new Text(
                                    "Browse For Image"
                                  ),
                                ),
                                onTap: () => getImageFromGallery(),
                              ),
                            ),
                            new SizedBox(
                              width: 20,
                            ),
                            new IconButton(
                              iconSize: 35,
                              color: Colors.black87,
                              icon: Icon(Icons.camera),
                              onPressed: () => getImageFromCamera(),
                            )
                          ],
                        ),
                        new SizedBox(
                          height: 10,
                        ),
                        _image == null ? SizedBox(
                          height: 0
                        ) : new Image.file(_image),
                        new SizedBox(
                          height: 15
                        ),
                        new MaterialButton(
                          child: new Text(
                            "Scan Image",
                            style: new TextStyle(
                              fontSize: 18
                            )
                          ),
                          onPressed: _image == null ? null : () => scanImage(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              new ActionButton(
                icon: isActive == false ? Icons.arrow_upward : Icons.arrow_downward,
                text: isActive == false ? "Show Upload Image" : "Hide Upload Image",
                onTap: () {
                  isActive == false ? setState(() {
                    isActive = true;
                    whiteHeight = 0.15;
                  }) : setState(() {  
                    isActive = false;
                    whiteHeight = 0.75;
                  });
                },
              ),
            ],
          ),
        ),
        new AnimatedContainer(
          duration: Duration(milliseconds: _duration),
          alignment: Alignment.topCenter,
          height: MediaQuery.of(context).size.height * whiteHeight,
          width: MediaQuery.of(context).size.width,
          decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.only(
              bottomLeft: Radius.circular(
                60
              ),
            ),
            boxShadow: [
              new BoxShadow(
                blurRadius: 15,
                color: Colors.black54
              ),
            ],
          ),
        ),
      ],
    );
  }
}