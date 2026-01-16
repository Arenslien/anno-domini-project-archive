import 'package:flutter/material.dart';

class InfoBody extends StatefulWidget {
  @override
  _InfoBodyState createState() => _InfoBodyState();
}

class _InfoBodyState extends State<InfoBody> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("내 정보"),
      ],
    );
  }
}