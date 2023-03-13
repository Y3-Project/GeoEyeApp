import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class ARViewPage extends StatefulWidget {
  const ARViewPage({Key? key}) : super(key: key);

  @override
  State<ARViewPage> createState() => _ARViewPageState();
}

class _ARViewPageState extends State<ARViewPage> {
  CameraController? cameraController; // controller for camera
  List<CameraDescription>? cameras; // list of devices cameras
  XFile? image; // for captured image

  @override
  void initState() {
    findCameras();
    super.initState();
  }

  void findCameras() async {
    cameras = await availableCameras();
    if (cameras == null) {
      print("NO CAMERAS FOUND!");
      return;
    }
    cameraController = CameraController(cameras![0], ResolutionPreset.max);
    cameraController!.initialize().then((value) {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.fromLTRB(0, 5, 0, 10),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.white),
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: cameraController == null
            ? Center(child: Text("Loading Camera..."))
            : !cameraController!.value.isInitialized
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : CameraPreview(cameraController!));
  }
}
