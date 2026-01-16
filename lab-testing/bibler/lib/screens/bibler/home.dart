import 'package:flutter/material.dart';

class HomeBody extends StatefulWidget {
  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.green[400],
              onPrimary: Colors.white,
            ),
            onPressed: () {

            },
            child: Text(
              "홈 화면",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      );
  }
}