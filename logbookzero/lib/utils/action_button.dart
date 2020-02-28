import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;

  ActionButton({this.text, this.onTap, this.icon});

  @override
  Widget build(BuildContext context) {
    return new Material(
      color: Colors.transparent,
      child: new Container(
        height: 100,
        child: new InkWell(
          onTap: onTap,
          child: new Center(
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                icon == null ? new SizedBox(
                  height: 0,
                ): new Icon(
                  icon,
                  size: 35,
                  color: Colors.white,
                ),
                new Text(
                  text,
                  style: new TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.w300
                  )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}