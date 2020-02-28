import 'package:flutter/material.dart';

class NavigationButton extends StatelessWidget {

  final IconData _icon;
  final String _title;
  final String _subtitle;

  NavigationButton(this._icon, this._title, this._subtitle);

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      leading: Icon(
        _icon,
        color: Colors.white
      ),
      title: new Text(
        _title,
        style: new TextStyle(
          color: Colors.white
        )
      ),
      subtitle: new Text(
        _subtitle,
        style: new TextStyle(
          color: Colors.white
        )
      ),
    );
  }
}