import 'package:flutter/material.dart';

class ListButton extends StatelessWidget {
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  ListButton({this.color, this.title, this.subtitle, this.onTap});


  @override
  Widget build(BuildContext context) {
    return new Material(
      color: color,
      child: new InkWell(
        onTap: onTap,
        child: new Padding(
          padding: EdgeInsets.all(10),
          child: new Column(
            children: <Widget>[
              new Text(
                title,
                style: new TextStyle(
                  fontSize: 19
                )
              ),
              new Text(
                subtitle
              )
            ],
          ),
        ),
      )
    );
  }
}