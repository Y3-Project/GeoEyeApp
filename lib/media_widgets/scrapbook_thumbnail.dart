import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../util/enums/media_type.dart';
import 'image_uploader_widget.dart';




class ScrapbookThumbnail extends StatefulWidget {
  final ValueChanged<MediaUploaderWidgetState> imageUploader;
  ScrapbookThumbnail({Key? key, required this.imageUploader}) : super(key: key);

  @override
  State<ScrapbookThumbnail> createState() => _ScrapbookThumbnailState();
}

class _ScrapbookThumbnailState extends State<ScrapbookThumbnail> {
  final imageUploaderWidgetStateKey = new GlobalKey<MediaUploaderWidgetState>();
  File picture = new File('');

  int scrapbookNumber = 0;

  String? getUuid() {
    String? uuid = '';
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    uuid = user?.uid;
    return uuid;
  }

  //TODO: Make picked image appear onto the inkwell
  /*
  Widget? getPicture(){
    if (picture.path == '')
      return Icon(Icons.add_a_photo, size: 40);
    else
      return
  }
   */

  @override
  Widget build(BuildContext context) {

    return InkWell(
        onTap: () {
          MediaUploaderWidget imageUploaderWidget =
          MediaUploaderWidget(key: imageUploaderWidgetStateKey, mediaType: MediaType.picture, fileName: "scrapbook_thumbnail");
          imageUploaderWidget.buildMediaUploader(imageUploaderWidget, context).then((value) => widget.imageUploader(imageUploaderWidgetStateKey.currentState!));
        },
        child: Icon(Icons.add_a_photo, size: 40)
    );
  }
}
