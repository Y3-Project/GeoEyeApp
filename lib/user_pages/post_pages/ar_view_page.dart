import 'dart:async';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_firebase_login/scrapbook_widgets/scrapbook.dart';
import 'package:flutter_app_firebase_login/scrapbook_widgets/scrapbook_tile.dart';

class ARViewPage extends StatefulWidget {
  const ARViewPage({Key? key}) : super(key: key);

  @override
  State<ARViewPage> createState() => _ARViewPageState();
}

class _ARViewPageState extends State<ARViewPage> {
  CameraController? cameraController; // controller for camera
  List<CameraDescription>? cameras; // list of devices cameras
  XFile? image; // for captured image
  late StreamSubscription stream;
  List<ScrapbookTile> _display = List.empty(growable: true);
  final CollectionReference scrapbookCollection =
      FirebaseFirestore.instance.collection('scrapbooks');

  @override
  void initState() {
    findCameras();
    findScrapbooks();
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

  List<Widget> setDisplayStack() {
    List<Widget> displayList = List.empty(growable: true);
    displayList.add(cameraController == null
        ? Center(child: Text("Loading Camera..."))
        : Stack(
            children: [
              Center(
                child: !cameraController!.value.isInitialized
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : CameraPreview(cameraController!),
                widthFactor: 100.0,
                heightFactor: 100.0,
              )
            ],
          ));
    for (var tile in _display) {
      if (tile.scrapbook.public) {
        // todo location
        displayList.add(tile);
      }
    }
    print(displayList.length);
    return displayList;
  }

  @override
  Widget build(BuildContext context) {
    Stack stack = Stack(children: setDisplayStack());
    return Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.fromLTRB(0, 5, 0, 10),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.white),
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: stack);
  }
}
