import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_firebase_login/post_widgets/title_caption_for_post.dart';
import '../media_widgets/media_uploader_widget.dart';
import '../scrapbook_widgets/make_a_scrapbook.dart';
import '../user_pages/main_page.dart';
import '../user_pages/profile_page.dart';
import '../util/enums/media_type.dart';

class AddPost extends StatefulWidget {
  final MediaUploaderWidgetState postUploader;
  final DocumentReference scrapbookRef;

  const AddPost({Key? key, required this.postUploader, required this.scrapbookRef}) : super(key: key);

  static String username = '';
  static String userDocID = '';

  static late DocumentReference postRef;

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> addPost() async {
    String postDir = await ProfilePage().getUserDocumentID() + "/scrapbooks/";

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
      'reports': List.empty(growable: true),
      'text': titleCaptionForPost.postCaption,
      'timestamp': Timestamp.now(),
      'title': titleCaptionForPost.postTitle,
      'user': userDocRef,
      'video': '',
      'postStoragePath': ''
    });
    print("Post added!" + "with postRef: " + AddPost.postRef.toString());
    //-------------------------POST SECTION ENDS------------------------------------------


    //-------------------------POST UPLOADING SECTION STARTS------------------------------
    String postId = AddPost.postRef.id;
    String scrapbookId = widget.scrapbookRef.id;
    String field = "";

    print(widget.postUploader.mediaFile.path);

    if (widget.postUploader.mediaType == MediaType.picture) {
      postDir = "/images/" + postDir + scrapbookId + "/posts/";
      field = "picture";
    } else {
      postDir = "/videos/" + postDir + scrapbookId + "/posts/";
      field = "video";
    }
    widget.postUploader.changeFileName(postId);
    String postStoragePath =
    await widget.postUploader.uploadMedia(postDir, "posts", postId, field);
    widget.postUploader.sendDataToFirestore(
        postStoragePath, 'posts', postId, 'postStoragePath');
    //-------------------------POST UPLOADING SECTION ENDS--------------------------------

    //-------------------------SCRAPBOOKPOST SECTION STARTS--------------------------------------
    await db
        .collection('scrapbookPosts')
        .add({'post': AddPost.postRef, 'scrapbook': widget.scrapbookRef}).then(
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
                  await addPost();
                  //------MAIN METHOD BELOW-------//
                  //---FOR NAVIGATING TO THE HOME PAGE---
                  setState(() {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => MainUserPage()),
                      //---FOR NAVIGATING TO THE HOME PAGE---
                    );
                  });
                },
                child: Text("Add Post",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
          ],
        ),
      ],
    ));
  }
}
