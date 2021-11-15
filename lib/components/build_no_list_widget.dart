import 'package:flutter/material.dart';

Widget noListData(IconData icon, String text) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: Colors.grey,
          size: 150,
        ),
        Text(
          text,
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 40,
              fontFamily: 'KoreanGothic'),
        ),
      ],
    ),
  );
}
