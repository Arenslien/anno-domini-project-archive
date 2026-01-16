import 'package:LocationApp/class/noble_location.dart';
import 'dart:math';

double getDistanceInMeterByHaversine(UserLocation userLocation, BibleVerseLocation bibleVerseLocation) {
  double distance;
  double radius = 6371; // 지구 반지름(km)
  double toRadian = pi / 180;

  double deltaLatitude = (userLocation.x - bibleVerseLocation.x).abs() * toRadian;
  double deltaLongitude = (userLocation.y - bibleVerseLocation.y).abs() * toRadian;

  double sinDeltaLat = sin(deltaLatitude / 2);
  double sinDeltaLng = sin(deltaLongitude / 2);
  double squareRoot = sqrt(
    sinDeltaLat * sinDeltaLat + cos(userLocation.x * toRadian) * cos(bibleVerseLocation.x * toRadian) * sinDeltaLng * sinDeltaLng
  );

  distance = 2 * radius * asin(squareRoot);
  return distance * 1000;

}
