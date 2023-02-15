import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart' as fire_core;

import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class ImageUploaderWidget extends StatefulWidget {
  final String storagePath;
  ImageUploaderWidget({required this.storagePath, required Key key})
      : super(key: key);

  @override
  State<ImageUploaderWidget> createState() => ImageUploaderWidgetState();
}

class ImageUploaderWidgetState extends State<ImageUploaderWidget> {
  late File image = File('');
  String imageURL = '';

  Future<File> pickImage(ImageSource imageSource) async {
    XFile? imgXFile = await ImagePicker().pickImage(source: imageSource);
    File imgFile = File('');
    if (imgXFile != null) {
      imgFile = File(imgXFile.path);
    }
    final String path =
        (await getApplicationDocumentsDirectory()).absolute.path;
    final finalImage = await imgFile.copy('$path/pickedPicture.png');
    return finalImage;
  }

  Future<String> uploadPicture(ImageSource imageSource) async {
    File picture = await pickImage(imageSource);

    final storageRef = FirebaseStorage.instance.ref();
    final imgRef = storageRef.child(widget.storagePath);
    String picStoragePath = '';

    try {
      await imgRef
          .putFile(picture)
          .snapshot
          .ref
          .getDownloadURL()
          .then((value) => picStoragePath = value);
    } on fire_core.FirebaseException catch (e) {
      print(e.toString());
    }

    //print(picStoragePath);

    imageURL = picStoragePath;

    showTopSnackBar(
      animationDuration: Duration(microseconds: 1000002),
      displayDuration: Duration(milliseconds: 95),
      Overlay.of(context)!,
      CustomSnackBar.info(
        backgroundColor: Colors.black,
        message:
            "Photo chosen"
      ),
    );

    return picStoragePath;
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
          Text(
            "Choose a picture",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Colors.white),
          ),
          SizedBox(
            height: 25,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            TextButton.icon(
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.white)),
              icon: Icon(Icons.camera),
              onPressed: () {
                uploadPicture(ImageSource.camera);
              },
              label: Text("Camera", style: TextStyle(color: Colors.black)),
            ),
            Divider(indent: 20),
            TextButton.icon(
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.white)),
              icon: Icon(Icons.image),
              onPressed: () {
                uploadPicture(ImageSource.gallery);
              },
              label: Text("Gallery", style: TextStyle(color: Colors.black)),
            ),
          ])
        ],
      ),
    );
  }
}
