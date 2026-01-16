import 'package:flutter/material.dart';

class CommunityBody extends StatefulWidget {
  @override
  _CommunityBodyState createState() => _CommunityBodyState();
}

class _CommunityBodyState extends State<CommunityBody> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("커뮤니티"),
      ],
    );
  }
}