import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_firebase_login/util/enums/media_type.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart' as fire_core;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class MediaUploaderWidget extends StatefulWidget {
  final MediaType mediaType;
  final String fileName;

  MediaUploaderWidget(
      {required Key key, required this.mediaType, required this.fileName})
      : super(key: key);

  Future<void> buildMediaUploader(
      MediaUploaderWidget mediaUploaderWidget, BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: ((builder) => mediaUploaderWidget),
    );
  }

  @override
  State<MediaUploaderWidget> createState() => MediaUploaderWidgetState();
}

class MediaUploaderWidgetState extends State<MediaUploaderWidget> {
  File mediaFile = File('');
  String fileName = "default_file";

  Future<File> pickMediaFile(ImageSource mediaSource) async {
    XFile? imgXFile = widget.mediaType == MediaType.picture
        ? await ImagePicker().pickImage(source: mediaSource)
        : await ImagePicker().pickVideo(source: mediaSource);
    File imgFile = File('');
    if (imgXFile != null) {
      imgFile = File(imgXFile.path);
    }
    String extension = p.extension(imgFile.path);
    final String path =
        (await getApplicationDocumentsDirectory()).absolute.path;
    final finalImage = await imgFile.copy('$path/' + fileName + extension);
    showTopSnackBar(
      animationDuration: Duration(microseconds: 1000002),
      displayDuration: Duration(milliseconds: 95),
      Overlay.of(context)!,
      CustomSnackBar.info(
          backgroundColor: Colors.black, message: "Photo Selected"),
    );
    return await finalImage;
  }

  Future<void> sendDataToFirestore(
      String data, String collection, String docId, String field) async {
    await FirebaseFirestore.instance
        .collection(collection)
        .doc(docId)
        .update({field: data});
  }

  Future<String> uploadMedia(
      String storageDir, String collection, String docId, String field) async {
    final storageRef = FirebaseStorage.instance.ref();
    final mediaStorageRef = storageRef.child(storageDir + fileName);
    String fileUrl = '';

    try {
      TaskSnapshot taskSnapshot = await mediaStorageRef.putFile(mediaFile);
      fileUrl = await taskSnapshot.ref.getDownloadURL();
    } on fire_core.FirebaseException catch (e) {
      print(e.toString());
    }
    sendDataToFirestore(fileUrl, collection, docId, field);
    return mediaStorageRef.fullPath;
  }

  void changeFileName(String newFileName) {
    fileName = newFileName;
  }

  @override
  Widget build(BuildContext context) {
    fileName = widget.fileName;
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
                pickMediaFile(ImageSource.camera)
                    .then((value) => mediaFile = value);
              },
              label: Text("Camera", style: TextStyle(color: Colors.black)),
            ),
            Divider(indent: 20),
            TextButton.icon(
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.white)),
              icon: Icon(Icons.image),
              onPressed: () {
                if (widget.mediaType == MediaType.picture)
                  pickMediaFile(ImageSource.gallery)
                      .then((value) => mediaFile = value);
                else
                  pickMediaFile(ImageSource.gallery)
                      .then((value) => mediaFile = value);
              },
              label: Text("Gallery", style: TextStyle(color: Colors.black)),
            ),
          ])
        ],
      ),
    );
  }
}
