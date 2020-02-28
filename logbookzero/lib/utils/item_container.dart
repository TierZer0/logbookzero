import 'package:flutter/material.dart';

class ItemContainer extends StatelessWidget {

  final Widget content;

  ItemContainer({this.content});

  @override
  Widget build(BuildContext context) {
    return new AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOutQuint,
      margin: EdgeInsets.only(
        top: 20,
        bottom: 10,
        right: 20
      ),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(20)
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 10
          )
        ]
      ),
      child: content,
    );
  }
}