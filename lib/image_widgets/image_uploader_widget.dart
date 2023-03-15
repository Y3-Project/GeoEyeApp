import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart' as fire_core;

import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class ImageUploaderWidget extends StatefulWidget {
  ImageUploaderWidget({required Key key})
      : super(key: key);

  Future<void> buildImageUploader (
      ImageUploaderWidget imageUploaderWidget, BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: ((builder) => imageUploaderWidget),
    );
  }

  @override
  State<ImageUploaderWidget> createState() => ImageUploaderWidgetState();
}

class ImageUploaderWidgetState extends State<ImageUploaderWidget> {
  File picture = File('');

  Future<File> pickImage(ImageSource imageSource) async {
    XFile? imgXFile = await ImagePicker().pickImage(source: imageSource);
    File imgFile = File('');
    if (imgXFile != null) {
      imgFile = File(imgXFile.path);
    }
    final String path =
        (await getApplicationDocumentsDirectory()).absolute.path;
    final finalImage = await imgFile.copy('$path/pickedPicture.png');

    showTopSnackBar(
      animationDuration: Duration(microseconds: 1000002),
      displayDuration: Duration(milliseconds: 95),
      Overlay.of(context)!,
      CustomSnackBar.info(
          backgroundColor: Colors.black,
          message:
          "Photo Selected"
      ),
    );
    return await finalImage;
  }

  Future<void> _sendPicToFirestore(String url, String collection, String docId, String field) async {
    await FirebaseFirestore.instance
        .collection(collection)
        .doc(docId)
        .update({field: url});
  }

  Future<String> uploadPicture(String storagePath, String collection, String docId, String field) async {
    final storageRef = FirebaseStorage.instance.ref();
    final imgRef = storageRef.child(storagePath);
    String picUrl = '';

    try {
      TaskSnapshot taskSnapshot = await imgRef
          .putFile(picture);
      picUrl = await taskSnapshot.ref.getDownloadURL();
    } on fire_core.FirebaseException catch (e) {
      print(e.toString());
    }
    print(picUrl);
    _sendPicToFirestore(picUrl, collection, docId, field);
    return picUrl;
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
                pickImage(ImageSource.camera).then((value) => picture = value);
              },
              label: Text("Camera", style: TextStyle(color: Colors.black)),
            ),
            Divider(indent: 20),
            TextButton.icon(
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.white)),
              icon: Icon(Icons.image),
              onPressed: () {
                pickImage(ImageSource.gallery).then((value) => picture = value);
              },
              label: Text("Gallery", style: TextStyle(color: Colors.black)),
            ),
          ])
        ],
      ),
    );
  }
}
