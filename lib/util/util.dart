import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

int distanceFromOneGeoPointToAnotherInKM(GeoPoint p1, GeoPoint p2) {
  final _geoLocatorPlatform = GeolocatorPlatform.instance;
  final res = _geoLocatorPlatform.distanceBetween(
      p1.latitude, p1.longitude, p2.latitude, p2.longitude);
  return (res ~/ 1000);
}
