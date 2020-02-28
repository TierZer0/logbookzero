import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/navigation_button.dart';

import '../ui/dashboard_ui.dart';
import '../ui/logbook_ui.dart';
import '../ui/tracker_ui.dart';
import '../ui/addDocument_ui.dart';
import '../ui/addLog_ui.dart';
import '../ui/upload_ui.dart';
class MainPage extends StatefulWidget {

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {

  @override
  initState() {
    super.initState();
  }

  int _selectedIndex = 0;
  final _options = [

    new DashboardView(),
    new LogbookView(),
    new TrackerView(),
    new AddDocumentView(),
    new AddLogView(),
    new UploadView()
  ];

  //final _darkText = new Color(0xFF263238);
  final _teal = new Color(0xFF00bcd4);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: _teal //or set color with: Color(0xFF0000FF)
    ));
    return new Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: new AppBar(
        elevation: 3,
        centerTitle: true,
        brightness: Brightness.dark,
        backgroundColor: _teal,
        title: new Text(
          "LogbookZero",
          style: new TextStyle(
            fontSize: 25
          )
        ),
        bottom: new PreferredSize(
          preferredSize: Size(20,10),
          child: new Text(
            "For Managing Your Logbook With Zero Effort",
            style: new TextStyle(
              color:Colors.white,
              fontSize: 15
            ),
          ),
        ),
        actions: <Widget>[
          new IconButton(
            icon: Icon(Icons.exit_to_app),
            tooltip: "Logout",
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
      body: _options.elementAt(_selectedIndex),
      drawer: new Drawer(
        elevation: 7,
        child: new Container(
          color: new Color(0xFF263238),
          child: new ListView(
            children: <Widget>[
              new Material(
                color: new Color(0xFF263238),
                child: new InkWell(
                  onTap: () {
                    setState(() {
                     _selectedIndex = 0;
                    });
                    Navigator.of(context).pop();
                  },
                  child: new NavigationButton(
                    Icons.flight,
                    "Flights",
                    "View All Flights"
                  ),
                ),
              ),
              new Material(
                color: new Color(0xFF263238),
                child: new InkWell(
                  onTap: () {
                    setState(() {
                     _selectedIndex = 1; 
                    });
                    Navigator.of(context).pop();
                  },
                  child: new NavigationButton(
                    Icons.table_chart,
                    "Table",
                    "Table View Of Logbook"
                  )
                ),
              ),
              new Material(
                color: new Color(0xFF263238),
                child: new InkWell(
                  onTap: () {
                    setState(() {
                      _selectedIndex = 2;
                    });
                    Navigator.of(context).pop();
                  },
                  child: new NavigationButton(
                    Icons.track_changes,
                    "Tracker",
                    "Monitor Flight Documents"
                  ),
                ),
              ),
              new Material(
                color: new Color(0xFF263238),
                child: new InkWell(
                  onTap: () {
                    setState(() {
                      _selectedIndex = 3;
                    });
                    Navigator.of(context).pop();
                  },
                  child: new NavigationButton(
                    Icons.book,
                    "Add Document",
                    "Add New Flight Document"
                  )
                ),
              ),
              new Material(
                color: new Color(0xFF263238),
                child: new InkWell(
                  onTap: () {
                    setState(() {
                      _selectedIndex = 4;
                    });
                    Navigator.of(context).pop();
                  },
                  child: new NavigationButton(
                    Icons.flight,
                    "Add Flight Log",
                    "Add New Flight Log"
                  ),
                ),
              ),
              new Material(
                color: new Color(0xFF263238),
                child: new InkWell(
                  onTap: () {
                    setState(() {
                      _selectedIndex = 5;
                    });
                    Navigator.of(context).pop();
                  },
                  child: new NavigationButton(
                    Icons.cloud_upload,
                    "Upload",
                    "Bulk Upload of Logbook"
                  ),
                ),
              ),
              new Material(
                color: new Color(0xFF263238),
                child: new InkWell(
                  onTap: () {
                    setState(() {
                      
                    });
                    Navigator.of(context).pop();
                  },
                  child: new NavigationButton(
                    Icons.info_outline,
                    "About",
                    "Information About LogbookZero"
                  ),
                ),
              )
            ],
          )
        ),
      ),
    );
  }
}