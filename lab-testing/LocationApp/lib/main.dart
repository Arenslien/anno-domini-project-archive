import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:LocationApp/function/harversine_formula.dart';
import 'package:LocationApp/class/noble_location.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Location Service App',
      debugShowCheckedModeBanner: false,
      home: LocationApp(),
    );
  }
}

class LocationApp extends StatefulWidget {
  @override
  _LocationAppState createState() => _LocationAppState();
}

class _LocationAppState extends State<LocationApp> {
  var _locationMessage = "";
  var _userLocation;
  var _bibleVerseLocation; // 다른 성경 좌표는 DB에서 받아와야함.
  // Geolocator geolocator = Geolocator.
  var locationStream = Stream.periodic(Duration(seconds: 1), (_) {

  });

  Future<UserLocation> getCurrentLocation() async {
    var position = await Geolocator
      .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    var lastPosition = await Geolocator.getLastKnownPosition();
    print(lastPosition);
    setState(() {
      _locationMessage = "$position";
      _userLocation = UserLocation(position.latitude, position.longitude);
    });
    return UserLocation(position.latitude, position.longitude);
  }

  void checkAroundLocation() {
    getDistanceInMeterByHaversine(_userLocation, _bibleVerseLocation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Services'),
        elevation: 0.0,
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.location_on,
              size: 50.0,
              color: Colors.blue,
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              'Get user Location',
              style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text("Position: $_locationMessage"),
            ElevatedButton(
              onPressed: () {
                getCurrentLocation();
              },
              child: Text("Get Current Location"),
            ),
          //   StreamBuilder(
          //     stream: ,
          //     builder: (context, ),
          //   ),
          ],
        ),
      )
    );
  }
}