import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_firebase_login/util/enums/media_type.dart';
import 'package:provider/provider.dart';

import '../util/user_model.dart';
import 'media_uploader_widget.dart';

final imageUploaderWidgetStateKey = new GlobalKey<MediaUploaderWidgetState>();
final String PROFILE_PICTURE_STORAGE_DIRECTORY_PATH = "/images/";

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
        MediaUploaderWidget imageUploaderWidget) async {
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
              String IMAGE_STORAGE_DIR =
                  PROFILE_PICTURE_STORAGE_DIRECTORY_PATH + user.id + '/';
              MediaUploaderWidget imageUploaderWidget = MediaUploaderWidget(
                key: imageUploaderWidgetStateKey,
                mediaType: MediaType.picture,
                fileName: 'profile_picture',
              );
              buildImageUploader(imageUploaderWidget).then((value) {
                imageUploaderWidgetStateKey.currentState!.uploadMedia(
                    IMAGE_STORAGE_DIR, 'users', user.id, 'profilePicture');
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
