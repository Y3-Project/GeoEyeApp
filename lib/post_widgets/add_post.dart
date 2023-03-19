import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_firebase_login/post_widgets/title_caption_for_post.dart';
import 'package:flutter_app_firebase_login/scrapbook_widgets/make_a_scrapbook.dart';
import 'package:flutter_app_firebase_login/user_pages/main_page.dart';
import 'package:flutter_app_firebase_login/util/enums/media_type.dart';

import '../media_widgets/media_uploader_widget.dart';
import '../scrapbook_widgets/scrapbook_title.dart';
import '../user_pages/profile_page.dart';

class AddPost extends StatefulWidget {
  final MediaUploaderWidgetState thumbnailUploader;
  final MediaUploaderWidgetState postUploader;

  AddPost(
      {Key? key, required this.postUploader, required this.thumbnailUploader})
      : super(key: key);

  static String username = '';
  static String userDocID = '';
  static late DocumentReference scrapbookRef;
  static late DocumentReference postRef;

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> addScrapbookPostMarker() async {
    String postDir = await ProfilePage().getUserDocumentID() + "/scrapbooks/";
    String scrapbookThumbnailDir =
        "/images/" + await ProfilePage().getUserDocumentID() + "/scrapbooks/";

    //-------------------------POST SECTION STARTS--------------------------------------
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
    AddPost.postRef = await posts.add({
      'likes': List.empty(growable: true),
      'picture': '',
      //todo get the download url from Storage and put it here IF user uploaded picture,
      'reports': List.empty(growable: true),
      'text': titleCaptionForPost.postCaption,
      'timestamp': Timestamp.now(),
      'title': titleCaptionForPost.postTitle,
      'user': userDocRef,
      'video': ''
      //todo get the download url from Storage and put it here IF user uploaded video,
    });
    print("Post added!" + "with postRef: " + AddPost.postRef.toString());
    //-------------------------POST SECTION ENDS------------------------------------------

    //-------------------------SCRAPBOOK SECTION STARTS--------------------------------------
    //for getting the "creatorid" field of the scrapbook; ('/users/' + AddPost.userDocID);
    CollectionReference posts1 = FirebaseFirestore.instance.collection('posts');
    QuerySnapshot<Map<String, dynamic>> snap2 = await FirebaseFirestore.instance
        .collection("users")
        .where("uuid", isEqualTo: ProfilePage().getUuid() as String)
        .get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docList2 = snap2.docs;
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in docList2) {
      AddPost.userDocID = doc.id;
    }

    //for accessing the current user's username; AddPost.username
    QuerySnapshot<Map<String, dynamic>> snap3 = await FirebaseFirestore.instance
        .collection("users")
        .where("uuid", isEqualTo: ProfilePage().getUuid() as String)
        .get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docList3 = snap3.docs;
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in docList3) {
      AddPost.username = doc['username'];
    }

    AddPost.scrapbookRef = await db.collection('scrapbooks').add({
      'creatorid': '/users/' + AddPost.userDocID,
      'currentUsername': AddPost.username,
      'location':
          GeoPoint(NewScrapbookPage.currentLat!, NewScrapbookPage.currentLong!),
      'public': NewScrapbookPage.visibility,
      'scrapbookThumbnail': '',
      'scrapbookTitle': ScrapbookTitle.scrapbookTitle,
      'timestamp': Timestamp.now()
    });
    print("Scrapbook added!" +
        "with scrapbookRef: " +
        AddPost.scrapbookRef.toString());

    //-------------------------SCRAPBOOK SECTION ENDS--------------------------------------

    //-------------------------THUMBNAIL UPLOADING SECTION STARTS-------------------------
    String scrapbookId = AddPost.scrapbookRef.id;

    scrapbookThumbnailDir += scrapbookId + "/";
    thumbnailUploader.uploadMedia(
        scrapbookThumbnailDir, "scrapbooks", scrapbookId, "scrapbookThumbnail");
    //-------------------------THUMBNAIL UPLOADING SECTION ENDS---------------------------

    //-------------------------POST UPLOADING SECTION STARTS------------------------------
    String postId = AddPost.postRef.id;
    String field = "";

    if (postUploader.widget.mediaType == MediaType.picture) {
      postDir = "/images/" + postDir + scrapbookId + "/posts/";
      field = "picture";
    } else {
      postDir = "/videos/" + postDir + scrapbookId + "/posts/";
      field = "video";
    }
    postUploader.changeFileName(postId);
    postUploader.uploadMedia(postDir, "posts", postId, field);
    //-------------------------POST UPLOADING SECTION ENDS--------------------------------

    //-------------------------MARKER SECTION STARTS--------------------------------------
    //add its corresponding marker
    await db.collection("markers").add({
      'location':
          GeoPoint(NewScrapbookPage.currentLat!, NewScrapbookPage.currentLong!),
      'uuid': ProfilePage().getUuid(),
      'scrapbookRef': AddPost.scrapbookRef
    }).then((documentSnapshot) => print("Marker added"));
    //-------------------------MARKER SECTION ENDS--------------------------------------

    //-------------------------SCRAPBOOKPOST SECTION STARTS--------------------------------------
    await db
        .collection('scrapbookPosts')
        .add({'post': AddPost.postRef, 'scrapbook': AddPost.scrapbookRef}).then(
            (documentSnapshot) => print("Scrapbook and Post linked!"));
    //-------------------------SCRAPBOOKPOST SECTION ENDS--------------------------------------
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
                  //------MAIN METHOD BELOW-------//
                  addScrapbookPostMarker();
                  //------MAIN METHOD BELOW-------//

                  //---FOR NAVIGATING TO THE HOME PAGE---
                  setState(() {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => MainUserPage()),
                    );
                  });
                  //---FOR NAVIGATING TO THE HOME PAGE---
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
