import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHome(),
    );
  }
}

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  Dio dio = new Dio();
  // dio.options.port
  void getHttp() async {
    try {
      var response = await dio.get("http://192.168.1.10:3000/test");
      print(response); 
    } catch(e) {
      print(e);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text("hi"),
          ElevatedButton(
            onPressed: () async {
              getHttp();
            },
            child: Text("Get"),
          )
        ],
      )
    );
  }
}