import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../util/user_model.dart';
import 'image_uploader_widget.dart';

final imageUploaderWidgetStateKey = new GlobalKey<ImageUploaderWidgetState>();
final String PROFILE_PICTURE_STORAGE_DIRECTORY_PATH = "";

class ImageProfileWidget extends StatefulWidget {
  const ImageProfileWidget({Key? key}) : super(key: key);

  @override
  State<ImageProfileWidget> createState() => _ImageProfileWidgetState();
}

class _ImageProfileWidgetState extends State<ImageProfileWidget> {



  @override
  Widget build(BuildContext context) {
    UserModel user = Provider.of<UserModel>(context);
    profilePictureURL url = profilePictureURL();

    Future<void> sendPicToFirestore(String url) async {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.id)
          .update({'profilePicture': url});
    }


    Future<void> checkImageUploader(ImageUploaderWidget imageUploaderWidget) async {
      await showModalBottomSheet(
        context: context,
        builder: ((builder) =>
        imageUploaderWidget),
      );
      sendPicToFirestore(imageUploaderWidgetStateKey.currentState!.imageURL);
    }

    ImageProvider<Object> getUserPicture() {
      if (user.profilePicture == "")
        return NetworkImage("https://firebasestorage.googleapis.com/v0/b/flutter-app-firebase-log-c1c41.appspot.com/o/images%2Fgeneral%2Fgeoeye.png?alt=media&token=d2fd885b-f0c5-409c-8ba0-23b3bf3195f2");
      else
        return NetworkImage(user.profilePicture);
    }

    return Center(
      child: ValueListenableBuilder<String>(
        valueListenable: url.urlPAth,
        builder: (con, value, _) {
          return Stack(children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.black,
              radius: 80.0,
              backgroundImage: getUserPicture(),
            ),
            Positioned(
              bottom: 10.0,
              right: 10.0,
              child: InkWell(
                onTap: () {
                  ImageUploaderWidget imageUploaderWidget = ImageUploaderWidget(key: imageUploaderWidgetStateKey, storagePath: '/images/' + user.id + '.png');
                  checkImageUploader(imageUploaderWidget);
                },
                child: Icon(
                  Icons.add_a_photo,
                  color: Colors.white,
                  size: 28.0,
                ),
              ),
            ),
          ]);
        },
      ),
    );
  }
}

class profilePictureURL with ChangeNotifier {
  String url = '';
  ValueNotifier<String> urlPAth = ValueNotifier<String>('');
}
