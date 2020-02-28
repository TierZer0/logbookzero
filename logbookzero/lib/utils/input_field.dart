import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class InputField extends StatelessWidget {

  final String label;
  final TextEditingController controller;
  final TextInputType type;
  final VoidCallback onTap;

  InputField({this.label, this.controller, this.type, this.onTap});

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: Platform.isIOS == true ? EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 15
      ) : EdgeInsets.symmetric(
        vertical: 7, 
        horizontal: 15
      ),
      child: new TextField(
        decoration: new InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            fontSize: 15
          ),
          hasFloatingPlaceholder: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))
          ),
          contentPadding: EdgeInsets.all(17) 
        ),
        style: new TextStyle(
          fontSize: 15
        ),
        controller: controller,
        keyboardType: type,
        onTap: onTap,
      ),
    );
  }
}