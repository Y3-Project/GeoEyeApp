import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_firebase_login/scrapbook_widgets/make_a_scrapbook.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import 'popup_card_style.dart';

class MapViewPage extends StatefulWidget {
  const MapViewPage({Key? key}) : super(key: key);
  static double? currentLat = 0;
  static double? currentLong = 0;

  @override
  State<MapViewPage> createState() => _MapViewPageState();
}

class _MapViewPageState extends State<MapViewPage> {
  List<Marker> allMarkers = [];
  late StreamSubscription<Position> positionStream;
  Position? currentPosition;

  final PopupController _popupLayerController = PopupController();

  @override
  void dispose() {
    super.dispose();
    positionStream.cancel();
  }

  @override
  void initState() {
    super.initState();
    listenToLocationChanges();
  }

  @override
  Widget build(BuildContext context) {
    LatLng latAndLong = LatLng(0.0, 0.0);

    /// Determine the current position of the device.
    ///
    /// When the location services are not enabled or permissions
    /// are denied the `Future` will return an error.
    void _determinePosition() async {
      bool serviceEnabled;
      LocationPermission permission;

      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled don't continue
        // accessing the position and request users of the
        // App to enable the location services.
        return Future.error('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissions are denied, next time you could try
          // requesting permissions again (this is also where
          // Android's shouldShowRequestPermissionRationale
          // returned true. According to Android guidelines
          // your App should show an explanatory UI now.
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      // When we reach here, permissions are granted and we can
      // continue accessing the position of the device.
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      //print("Current position: $position");
      MapViewPage.currentLat = position?.latitude;
      MapViewPage.currentLong = position?.longitude;
    }

    _determinePosition();

    if (NewScrapbookPage.currentLat == 0.0 &&
        NewScrapbookPage.currentLong == 0.0) {
      latAndLong = LatLng(MapViewPage.currentLat!, MapViewPage.currentLong!);
      setState(() {});
    } else {
      latAndLong =
          LatLng(NewScrapbookPage.currentLat!, NewScrapbookPage.currentLong!);
      setState(() {});
    }

    Widget loadMap() {
      return StreamBuilder(
          stream: FirebaseFirestore.instance.collection('markers').snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            int? docsLength = snapshot.data?.docs.length;

            if (!snapshot.hasData) {
              return Text('Loading Map...PLease wait');
            }
            for (int i = 0; i < docsLength!; i++) {
              allMarkers.add(new Marker(
                  width: 45.0,
                  height: 45.0,
                  point: new LatLng(snapshot.data?.docs[i]['location'].latitude,
                      snapshot.data?.docs[i]['location'].longitude),
                  builder: (context) => new Icon(Icons.location_on)));
            }
            return FlutterMap(
              options: MapOptions(
                center: latAndLong,
                zoom: 14,
                onTap: (_, __) => _popupLayerController.hideAllPopups(),
              ),
              nonRotatedChildren: [],
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                PopupMarkerLayerWidget(
                  options: PopupMarkerLayerOptions(
                    popupAnimation: PopupAnimation.fade(curve: Curves.bounceIn),
                    popupController: _popupLayerController,
                    markers: allMarkers,
                    markerRotateAlignment:
                        PopupMarkerLayerOptions.rotationAlignmentFor(
                            AnchorAlign.top),
                    popupBuilder: (BuildContext context, Marker marker) =>
                        MarkerPopup(marker),
                  ),
                ),
              ],
            );
          });
    }

    return loadMap();
  }

  void listenToLocationChanges() {
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );
    positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
      (Position? position) {
        print(position == null ? 'Unknown' : '$position');
        setState(() {
          MapViewPage.currentLat = position?.latitude;
          MapViewPage.currentLong = position?.longitude;
        });
      },
    );
  }
}
