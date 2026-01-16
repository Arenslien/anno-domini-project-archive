import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

void main() {
  runApp(MyApp());
  Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Test',
      home: MyHome(),
    );
  }
}

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {

  DatabaseReference db = FirebaseDatabase.instance.reference();
  String inputValue;
  String createValue = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Database Test'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width/2,
                  child: TextField(
                    decoration: InputDecoration(
                      filled: true,
                      hintText: "입력한 값이 생성됩니다.",
                    ),
                    minLines: 1,
                    maxLines: 1,
                    maxLength: 20,
                    onChanged: (String value) {
                      createValue = value;
                    },
                  ),
                ),
                SizedBox(width: 20.0),
                ElevatedButton(
                  onPressed: () {
                    print(createValue);
                    if(createValue.isNotEmpty) {
                      db.child("title").push().set({"name" : createValue});
                    } else {
                      print("NONONO!");
                    }
                  },
                  child: Text('CREATE'),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {

              },
              child: Text('READ'),
            ),
            ElevatedButton(
              onPressed: () {

              },
              child: Text('UPDATE'),
            ),
            ElevatedButton(
              onPressed: () {
                db.child("title").child("name").remove();
              },
              child: Text('DELETE'),
            ),


            Text('good'),
            StreamBuilder(
              stream: db.child("title").onValue,
              builder: (context, AsyncSnapshot<Event> snap) {
                if(!snap.hasData) return Text('로딩중');
                return Text(snap.data.snapshot.value.toString());
              }
            ),
            StreamBuilder(
              stream: db.child("listTitle").onValue,
              builder: (context, AsyncSnapshot<Event> snap) {
                if(!snap.hasData) return Text('로딩중');
                return Column(
                  children: [
                    Text(snap.data.snapshot.value.runtimeType.toString()),
                    Text(snap.data.snapshot.value.toString()),
                    Text(snap.data.snapshot.value[0].toString()),
                  ],
                );
              },
            ),
            StreamBuilder(
              stream: db.child("mapTitle").onValue,
              builder: (context, AsyncSnapshot<Event> snap) {
                if(!snap.hasData) return Text('로딩중');
                return Column(
                  children: [
                    Text(snap.data.snapshot.value.runtimeType.toString()),
                    Text(snap.data.snapshot.value.toString()),
                    Text(snap.data.snapshot.value[0]['name'].toString()),
                  ],
                );
              },
            )
          ],
        )
      )
    );
  }
}