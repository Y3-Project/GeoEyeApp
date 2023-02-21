import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart' as fire_core;

import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class VideoUploaderWidget extends StatefulWidget {
  final String storagePath;
  VideoUploaderWidget({required this.storagePath, required Key key})
      : super(key: key);

  @override
  State<VideoUploaderWidget> createState() => VideoUploaderWidgetState();
}

class VideoUploaderWidgetState extends State<VideoUploaderWidget> {
  late File video = File('');
  String videoURL = '';

  Future<File> pickVideo(ImageSource imageSource) async {
    XFile? videoXFile = await ImagePicker().pickVideo(source: imageSource);
    File videoFile = File('');
    if (videoXFile != null) {
      videoFile = File(videoXFile.path);
    }
    final String path =
        (await getApplicationDocumentsDirectory()).absolute.path;
    final finalVideo = await videoFile.copy('$path/pickedVideo.png');
    return finalVideo;
  }

  Future<String> uploadVideo(ImageSource imageSource) async {
    File picture = await pickVideo(imageSource);

    final storageRef = FirebaseStorage.instance.ref();
    final videoRef = storageRef.child(widget.storagePath);
    String videoStoragePath = '';

    try {
      await videoRef
          .putFile(picture)
          .snapshot
          .ref
          .getDownloadURL()
          .then((value) => videoStoragePath = value);
    } on fire_core.FirebaseException catch (e) {
      print(e.toString());
    }

    //print(videoStoragePath);

    videoURL = videoStoragePath;

    showTopSnackBar(
      animationDuration: Duration(microseconds: 1000002),
      displayDuration: Duration(milliseconds: 95),
      Overlay.of(context)!,
      CustomSnackBar.info(
          backgroundColor: Colors.black,
          message:
          "Video Selected"
      ),
    );

    return videoStoragePath;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 0.1,
        vertical: 0.1,
      ),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 25,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            TextButton.icon(
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.white)),
              icon: Icon(Icons.camera),
              onPressed: () {
                uploadVideo(ImageSource.camera);
              },
              label: Text("Camera", style: TextStyle(color: Colors.black)),
            ),
            Divider(indent: 20),
            TextButton.icon(
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.white)),
              icon: Icon(Icons.image),
              onPressed: () {
                uploadVideo(ImageSource.gallery);
              },
              label: Text("Gallery", style: TextStyle(color: Colors.black)),
            ),
          ])
        ],
      ),
    );
  }
}
