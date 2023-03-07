import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_firebase_login/scrapbook_widgets/make_a_scrapbook.dart';
import '../image_widgets/image_uploader_widget.dart';
import '../video_widgets/video_uploader_widget.dart';

final imageUploaderWidgetStateKey = new GlobalKey<ImageUploaderWidgetState>();
final String SCRAPBOOK_THUMBNAIL_STORAGE_DIRECTORY_PATH = "";

class ImageVideoPost extends StatefulWidget {
  const ImageVideoPost({Key? key}) : super(key: key);

  @override
  State<ImageVideoPost> createState() => _ImageVideoPostState();
}

class _ImageVideoPostState extends State<ImageVideoPost> {
  int postNumber = 0;

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

    ;

    Future<void> checkVideoUploader(
        VideoUploaderWidget videoUploaderWidget) async {
      await showModalBottomSheet(
        context: context,
        builder: ((builder) => videoUploaderWidget),
      );
    }

    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      InkWell(
          onTap: () {
            ImageUploaderWidget imageUploaderWidget = ImageUploaderWidget(
                key: imageUploaderWidgetStateKey,
                storagePath:
                    '/images/scrapbookPosts/' + //change this path if it doesn't work for the profile picture, etc
                        postNumber.toString() +
                        "-" +
                        getUuid().toString() +
                        '.png');
            checkImageUploader(imageUploaderWidget);
          },
          child: Image.asset('images/add_img.png', height: 100)),
      // Divider(indent: 90),
      InkWell(
          //todo : upload videos to Storage in onTap function below
          onTap: () {
            VideoUploaderWidget videoUploaderWidget = VideoUploaderWidget(
                key: imageUploaderWidgetStateKey,
                storagePath:
                    '/videos/scrapbookPosts/' + //change this path if it doesn't work for the profile picture, etc
                        postNumber.toString() +
                        "-" +
                        getUuid().toString());
            checkVideoUploader(videoUploaderWidget);
          },
          child: Icon(Icons.video_call_rounded, size: 100))
    ]);
  }
}
