import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  hintText: 'Email',
  fillColor: Colors.white,
  filled: true,
  prefixIcon: Padding(
    padding: EdgeInsets.all(0.0),
    child: Icon(
      Icons.email,
      color: Colors.grey,
    ), // icon is 48px widget.
  ),
  enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 2.0)),
  focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blue, width: 2.0)),
);
