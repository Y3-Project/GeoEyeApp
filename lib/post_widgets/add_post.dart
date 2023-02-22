import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_firebase_login/post_widgets/image_or_video_post.dart';
import 'package:flutter_app_firebase_login/post_widgets/title_caption_for_post.dart';
import 'package:flutter_app_firebase_login/scrapbook_widgets/make_a_scrapbook.dart';
import 'package:flutter_app_firebase_login/scrapbook_widgets/scrapbook_title.dart';
import 'package:flutter_app_firebase_login/user_pages/post_pages/map_view_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../user_pages/profile_widget.dart';
import '../util/user_model.dart';

class AddPost extends StatefulWidget {
  AddPost({Key? key}) : super(key: key);

  static String username = '';

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {

  //todo add third argument to addPost method below for url of image/video
  Future<void> addPost(String title, String desc) async {
    CollectionReference posts = FirebaseFirestore.instance.collection('posts');
    String userDocID = '';
    QuerySnapshot<Map<String, dynamic>> snap = await FirebaseFirestore.instance
        .collection("users")
        .where("uuid", isEqualTo: ProfilePage().getUuid() as String)
        .get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docList = snap.docs;
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in docList) {
      userDocID = doc.id;
    }
    DocumentReference userDocRef =
        FirebaseFirestore.instance.doc('/users/' + userDocID);
    await posts.add({
      'likes': List.empty(growable: true),
      'picture': '',
      'reports': List.empty(growable: true),
      'text': desc,
      'timestamp': Timestamp.now(),
      'title': title,
      'user': userDocRef,
      'video': ''
    });
    print("Post added!");

    //todo add the newly created scrapbook to the "scrapbook" collection in Firestore as well,
    //so create a method here called addScrapbook like above



  }

  @override
  Widget build(BuildContext context) {

    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.black),
                    textStyle: MaterialStateTextStyle.resolveWith(
                        (states) => TextStyle(color: Colors.white))),
                onPressed: () async {
                  // TODO: Implement uploading pictures and videos with a post

                  //----------------------------ARGUMENTS NEEDED FOR MAKING A SCRAPBOOK-----------------------------------------
                  //for getting the uuid of the current user; ProfilePage().getUuid())
                  //for accessing the scrapbook's Title; ScrapbookTitle.scrapbookTitle
                  //for accessing the download url of the scrapbook thumbnail: [INSERT HERE] [IF NULL, FILL IT WITH "images/default_image.png"

                  QuerySnapshot<Map<String, dynamic>> snap = await FirebaseFirestore.instance
                      .collection("users")
                      .where("uuid", isEqualTo: ProfilePage().getUuid() as String)
                      .get();
                  List<QueryDocumentSnapshot<Map<String, dynamic>>> docList = snap.docs;
                  for (QueryDocumentSnapshot<Map<String, dynamic>> doc in docList) {
                    AddPost.username = doc['username'];
                  }
                  //for accessing the current user's username; AddPost.username

                  //for getting the user's current location, NewScrapbookPage.currentLat AND NewScrapbookPage.currentLong

                  //CALL THE METHOD addScrapbook HERE (NOT CREATED YET)

                  //----------------------------ARGUMENTS NEEDED FOR MAKING A SCRAPBOOK-----------------------------------------


                  //----------------------------ARGUMENTS NEEDED FOR MAKING A POST-----------------------------------------
                  //for getting the title of the post; titleCaptionForPost.postTitle;
                  //for getting the caption of the post; titleCaptionForPost.postCaption;
                  //for the getting the download url of an image, if an image was selected as the post [INSERT HERE]
                  //OR alternatively, see below comment
                  //for the getting the download url of a video, if a video was selected as the post [INSERT HERE]

                  //CALL THE METHOD addPost HERE

                  //----------------------------ARGUMENTS NEEDED FOR MAKING A POST-----------------------------------------


                  //


                  /*
                    Directory appDocDir = await getApplicationDocumentsDirectory();
                    String picturePath = appDocDir.absolute.path.toString() + '/add_img.png';
                    File pictureFile = File(picturePath);
                    Image image = Image(image: AssetImage('images/add_img.png'));



                    bool t = await pictureFile.exists();
                    print(t.toString());

                     */

                  //uploadPicture(pictureFile);
                },
                child: Text("Create the scrapbook",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
          ],
        ),
      ],
    ));
  }
}
