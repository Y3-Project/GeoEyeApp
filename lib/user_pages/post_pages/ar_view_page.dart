import 'dart:async';

import 'package:ar_location_view/ar_annotation.dart';
import 'package:ar_location_view/ar_location_widget.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_firebase_login/scrapbook_widgets/scrapbook.dart';
import 'package:flutter_app_firebase_login/scrapbook_widgets/scrapbook_tile.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';
import '../../util/util.dart';

class Annotation extends ArAnnotation {
  Annotation({required super.uid, required super.position});
}

class ARViewPage extends StatefulWidget {
  const ARViewPage({Key? key}) : super(key: key);

  @override
  State<ARViewPage> createState() => _ARViewPageState();
}

class _ARViewPageState extends State<ARViewPage> {
  CameraController? cameraController; // controller for camera
  List<CameraDescription>? cameras; // list of devices cameras
  late StreamSubscription stream;
  List<ScrapbookTile> _display = List.empty(growable: true);
  List<Annotation> _displayAnnotations = List.empty(growable: true);
  final CollectionReference scrapbookCollection =
      FirebaseFirestore.instance.collection('scrapbooks');

  @override
  void initState() {
    findCameras();
    findScrapbooks();
    loadAnnotations();
    super.initState();
  }

  void findCameras() async {
    cameras = await availableCameras();
    if (cameras == null) {
      print("NO CAMERAS FOUND!");
      return;
    }
    print(cameras!.length);
    cameraController = CameraController(cameras![0], ResolutionPreset.max);
    cameraController!.initialize().then((value) {
      if (!mounted) return;
      setState(() {});
    });
  }

  void findScrapbooks() async {
    scrapbookCollection.snapshots().listen((event) {
      for (var doc in event.docs) {
        _display.add(ScrapbookTile(Scrapbook.fromDocument(doc)));
      }
    });
  }

  void loadAnnotations() {
    for (var tile in _display) {
      if (tile.scrapbook.public) {
        Position pos = Position(
            longitude: tile.scrapbook.location.longitude,
            latitude: tile.scrapbook.location.latitude,
            timestamp: DateTime.now(),
            accuracy: 0.0,
            altitude: 0.0,
            heading: 0.0,
            speed: 0.0,
            speedAccuracy: 0.0);
        Annotation annon = Annotation(uid: Uuid().v1(), position: pos);
        _displayAnnotations.add(annon);
      }
    }
  }

  List<Widget> setDisplayStack() {
    List<Widget> displayList = List.empty(growable: true);

    // displayList.add(arLocationWidget);
    print(displayList.length);
    return displayList;
  }

  @override
  Widget build(BuildContext context) {
    Stack stack = Stack(children: setDisplayStack());
    return Scaffold(
        body: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.fromLTRB(0, 5, 0, 10),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.white),
                borderRadius: const BorderRadius.all(Radius.circular(20))),
            child: ArLocationWidget(
                annotations: _displayAnnotations,
                annotationViewBuilder: (context, annotation) {
                  return _display[0];
                },
                onLocationChange: ((Position position) {}))));
  }
}
