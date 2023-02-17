import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'image_uploader_widget.dart';

final imageUploaderWidgetStateKey = new GlobalKey<ImageUploaderWidgetState>();
final String SCRAPBOOK_THUMBNAIL_STORAGE_DIRECTORY_PATH = "";

class ScrapbookThumbnail extends StatefulWidget {
  const ScrapbookThumbnail({Key? key}) : super(key: key);

  @override
  State<ScrapbookThumbnail> createState() => _ScrapbookThumbnailState();
}

class _ScrapbookThumbnailState extends State<ScrapbookThumbnail> {

  int scrapbookNumber = 0;

  String? getUuid() {
    String? uuid = '';
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    uuid = user?.uid;
    return uuid;
  }

  @override
  Widget build(BuildContext context) {

    Future<void> checkImageUploader(
        ImageUploaderWidget imageUploaderWidget) async {
      await showModalBottomSheet(
        context: context,
        builder: ((builder) => imageUploaderWidget),
      );
    }

    return InkWell(
        onTap: () {
          ImageUploaderWidget imageUploaderWidget = ImageUploaderWidget(
              key: imageUploaderWidgetStateKey,
              storagePath: '/images/scrapBookThumbnail' + scrapbookNumber.toString() + "-"+ getUuid().toString() + '.png');
          checkImageUploader(imageUploaderWidget);
        },
        child: Icon(Icons.add_a_photo, size: 40));
  }
}
