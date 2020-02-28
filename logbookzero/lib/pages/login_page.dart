import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'dart:io';

import '../services/auth.dart';

import '../utils/input_field.dart';
import '../utils/action_button.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {


  @override
  initState() {
    super.initState();
    authService.currentUser = "";
    
  }
  final _darkText = new Color(0xFF263238);
  final _teal = new Color(0xFF00bcd4);

  final emailController = new TextEditingController();
  final passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: _teal //or set color with: Color(0xFF0000FF)
    ));
    return new MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: new AppBar(
          backgroundColor: _teal,
          centerTitle: true,
          brightness: Brightness.dark,
          elevation: 3,
          title: new Text(
            "LogbookZero",
            style: new TextStyle(
              color: Colors.white,
              fontSize: 25
            ),
          ),
          bottom: new PreferredSize(
            preferredSize: Size(10,10),
            child: new Text(
              "For Managing Your Logbook With Zero Effort",
              style: new TextStyle(
                color: Colors.white,
                fontSize: 15
              )
            ),
          ),
        ),
        body: new Stack(
          children: <Widget>[
            new Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.all(0),
              padding: EdgeInsets.only(
                bottom: 10
              ),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: new BoxDecoration(
                color: _teal
              ),
              child: new Align(
                alignment: Alignment.bottomCenter,
                child: new ActionButton(
                  text: "Google Login",
                  onTap: () {
                    authService.googleSignIn().then((result) {
                      authService.currentUser = result.uid;
                      Navigator.of(context).pushNamed('/main');
                    });
                  },
                ),
              ),
            ),
            new Container(
              height: MediaQuery.of(context).size.height * .75,
              decoration: new BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  new BoxShadow(
                    color: Colors.black45,
                    blurRadius: 10
                  )
                ],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(60)
                )
              ),
            ),
            new Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * .10,
                left: 20,
                right: 20
              ),
              height: 450,
              child: new Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20)
                  ),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 12,
                      color: Colors.black54
                    )
                  ]
                ),
                child: new Padding(
                  padding: EdgeInsets.all(20),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Text(
                        "Login To Account",
                        style: new TextStyle(
                          fontSize: 25,
                          color: _darkText
                        ),
                      ),
                      new Text(
                        "If Creating An Account, Enter Email and Password and Login",
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                          color: _darkText
                        ),
                      ),
                      new SizedBox(
                        height: 10,
                      ),
                      new InputField(
                        label: "Enter Your Email",
                        controller: emailController,
                        type: TextInputType.emailAddress
                      ),
                      new SizedBox(
                        height: 10
                      ),
                      new Padding(
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                        child: new TextFormField(
                          decoration: const InputDecoration(
                            labelText: "Enter Your Password",
                            hasFloatingPlaceholder: true,
                            border:OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                            ),
                            contentPadding: EdgeInsets.all(17)
                          ),
                          controller: passwordController,
                          obscureText: true,
                        ), 
                      ),
                      new SizedBox(
                        height: 20,
                      ),
                      new MaterialButton(
                        child: new Text(
                          "Login",
                          style: new TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w300
                          ),
                        ),
                        onPressed: () {

                        },
                        color: _teal,
                        minWidth: 200,
                        elevation: 5,
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}