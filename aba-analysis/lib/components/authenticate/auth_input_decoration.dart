import 'package:flutter/material.dart';

InputDecoration buildAuthInputDecoration(String hintText, IconData iconData) {
  return InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide.none,
    ),
    filled: true,
    fillColor: Colors.grey[200],
    hintText: hintText, 
    prefixIcon: Icon(iconData, color: Colors.grey[600]) 
  );
}