import 'package:flutter/material.dart';

import './pages/login_page.dart';
import './pages/main_page.dart';

void main() => runApp(new LogbookZero());

class LogbookZero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new LoginPage(),
      routes: <String, WidgetBuilder>{
        '/login' : (BuildContext context) => new LoginPage(),
        '/main': (BuildContext context) => new MainPage()
      },
    );
  }
}

