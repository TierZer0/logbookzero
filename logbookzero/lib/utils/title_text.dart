import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {

  final String text;
  final double size;

  TitleText({this.text, this.size});
  
  
  @override
  Widget build(BuildContext context) {
    return new Align(
      alignment: Alignment.topCenter,
      child: new Text(
        text,
        style: new TextStyle(
          fontSize: size
        ),
      ),
    );
  }
}