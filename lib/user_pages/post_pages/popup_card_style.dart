import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_firebase_login/scrapbook_widgets/marker_scrapbook.dart';
import 'package:flutter_app_firebase_login/scrapbook_widgets/scrapbook.dart';
import 'package:flutter_map/flutter_map.dart';

class MarkerPopup extends StatefulWidget {
  final Marker marker;
  static String currentUsername = '';

  const MarkerPopup(this.marker, {Key? key}) : super(key: key);

  static late String scrapbookReference = '';

  static Scrapbook markerScrapbook = Scrapbook(
      id: '',
      creatorid: '',
      scrapbookTitle: '',
      scrapbookThumbnail: '',
      currentUsername: '',
      location: GeoPoint(0.0, 0.0),
      timestamp: Timestamp.now(),
      public: false,
      thumbnailStoragePath: '');

  @override
  State<StatefulWidget> createState() => _MarkerPopupState();
}

class _MarkerPopupState extends State<MarkerPopup> {
  final List<IconData> _icons = [Icons.remove_red_eye_outlined];
  int _currentIcon = 0;
  late StreamSubscription _stream;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => setState(() {
          _currentIcon = (_currentIcon + 1) % _icons.length;
        }),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 10),
              child: Icon(_icons[_currentIcon]),
            ),
            _cardDescription(context),
          ],
        ),
      ),
    );
  }

  Widget _cardDescription(BuildContext context) {
    var inst = FirebaseFirestore.instance.collection("markers").where(
        "location",
        isEqualTo: GeoPoint(
            widget.marker.point.latitude, widget.marker.point.longitude));
    inst.snapshots().listen((event) {
      for (var doc in event.docs) {
        MarkerPopup.scrapbookReference = doc['scrapbookRef'].toString();
      }
    });

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        constraints: const BoxConstraints(minWidth: 100, maxWidth: 200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Your Scrapbook\'s Coordinates: \n \n${widget.marker.point.latitude} Latitude, \n${widget.marker.point.longitude} Longitude',
              style:
                  const TextStyle(fontSize: 11.4, fontWeight: FontWeight.bold),
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => MarkerScrapbook()),
                  );
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.black)),
                child: Text('Go To Scrapbook'))
          ],
        ),
      ),
    );
  }
}
