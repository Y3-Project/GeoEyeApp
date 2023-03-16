import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../util/user_model.dart';
import 'image_uploader_widget.dart';

final imageUploaderWidgetStateKey = new GlobalKey<ImageUploaderWidgetState>();
final String PROFILE_PICTURE_STORAGE_DIRECTORY_PATH = "/images/";
final String PROFILE_PICTURE_NAME = "profile_picture.png";

class ImageProfileWidget extends StatefulWidget {
  const ImageProfileWidget({Key? key}) : super(key: key);

  @override
  State<ImageProfileWidget> createState() => _ImageProfileWidgetState();
}

class _ImageProfileWidgetState extends State<ImageProfileWidget> {
  @override
  Widget build(BuildContext context) {
    UserModel user = Provider.of<UserModel>(context);

    Future<void> buildImageUploader(
        ImageUploaderWidget imageUploaderWidget) async {
      await showModalBottomSheet(
        context: context,
        builder: ((builder) => imageUploaderWidget),
      );
    }

    return Center(
      child: Stack(children: <Widget>[
        CircleAvatar(
          backgroundColor: Colors.black,
          radius: 80.0,
          backgroundImage: user.profilePicture == ''
              ? Image(
                  image: AssetImage('images/default_avatar.png'),
                ).image
              : NetworkImage(user.profilePicture),
        ),
        Positioned(
          bottom: 10.0,
          right: 10.0,
          child: InkWell(
            onTap: () {
              // TODO: fix the Firestore storage path for profile pictures
              String IMAGE_STORAGE_PATH =
                  PROFILE_PICTURE_STORAGE_DIRECTORY_PATH +
                      user.id +
                      '/' +
                      PROFILE_PICTURE_NAME;
              ImageUploaderWidget imageUploaderWidget =
                  ImageUploaderWidget(key: imageUploaderWidgetStateKey);
              buildImageUploader(imageUploaderWidget).then((value) {
                imageUploaderWidgetStateKey.currentState!.uploadPicture(
                    IMAGE_STORAGE_PATH, 'users', user.id, 'profilePicture');
              });
            },
            child: Icon(
              Icons.add_a_photo,
              color: Colors.white,
              size: 28.0,
            ),
          ),
        ),
      ]),
    );
  }
}
