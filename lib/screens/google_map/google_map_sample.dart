import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapSample extends StatefulWidget {
  const GoogleMapSample({Key? key}) : super(key: key);

  @override
  State<GoogleMapSample> createState() => _GoogleMapSampleState();
}

class _GoogleMapSampleState extends State<GoogleMapSample> {
  Completer<GoogleMapController> _controller = Completer();

  Set<Marker> markers = {};

  static final CameraPosition _kGooglePlex = CameraPosition(
      target: LatLng(37.42796133580664, -122.085749655962), zoom: 14.4746);

  bool isAllowed = false;
  late Position position;
  late StreamSubscription<Position> streamSubscription;

  void initState() {
    super.initState();
    getData();
  }

//기본 exception만 다룬 것으로 추후에 다른 예외들 추가할 예정
  void getData() async {
    try {
      position = await _getCurrent();

      setState(() {
        this.isAllowed = true;
      });
    } catch (PermissionDefinitionsNotFoundException) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please allow permission to use the service.')));
    } catch (LocationServiceDisabledException) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please activate your Gps')));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: size.width,
            height: size.height * 0.75,
            child: GoogleMap(
              markers: markers,
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ),
          ElevatedButton.icon(
            onPressed: !isAllowed
                ? null
                : () async {
                    final GoogleMapController controller =
                        await _controller.future;
                    controller.animateCamera(
                        CameraUpdate.newCameraPosition(CameraPosition(
                      target: LatLng(position.latitude, position.longitude),
                      zoom: 14,
                    )));

                    markers.add(Marker(
                      markerId: MarkerId('current Location'),
                      position: LatLng(position.latitude, position.longitude),
                    ));

                    setState(() {});
                  },
            label: Text('Go to the current'),
            icon: Icon(Icons.location_on),
          ),
          ElevatedButton.icon(
            onPressed: !isAllowed
                ? null
                : () {
                    double latitude = position.latitude;
                    double longitude = position.longitude;
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('lat : $latitude / lng : $longitude'),
                      duration: Duration(seconds: 2),
                    ));
                  },
            label: Text('Show lng/lat'),
            icon: Icon(Icons.location_searching_sharp),
          ),
          ElevatedButton.icon(
            onPressed: !isAllowed
                ? null
                : () {
                    getAddressFromLatLang(position, context);
                  },
            label: Text('Show address'),
            icon: Icon(Icons.home),
          )
        ],
      ),
    );
  }
}

Future<Position> _getCurrent() async {
  bool serviceEnabled;
  LocationPermission permission;
  serviceEnabled = await Geolocator.isLocationServiceEnabled();

  if (!serviceEnabled) {
    throw LocationServiceDisabledException;
    // return Future.error('Location services are disabled');
  }

  permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      throw PermissionDefinitionsNotFoundException;
      // return Future.error('Location Permission denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error('Location permissions are permanently denied');
  }

  Position position = await Geolocator.getCurrentPosition();
  return position;
}

Future<void> getAddressFromLatLang(
    Position position, BuildContext context) async {
  Map addressMap = {'admin': '', 'subAdmin': '', 'local': '', 'thorough': ''};
  late String address = '';

  try {
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemark[0];

    addressMap['admin'] = place.administrativeArea;
    addressMap['subAdmin'] = place.subAdministrativeArea;
    addressMap['local'] = place.locality;
    addressMap['thorough'] = place.thoroughfare;

    addressMap.forEach((key, value) {
      if (value != '') {
        address = address + value + ' ';
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(address),
      duration: Duration(seconds: 2),
    ));
  } catch (e) {
    print(e);
  }
}
