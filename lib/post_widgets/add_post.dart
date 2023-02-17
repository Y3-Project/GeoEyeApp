import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_firebase_login/post_widgets/image_or_video_post.dart';
import 'package:flutter_app_firebase_login/post_widgets/title_caption_for_post.dart';
import 'package:flutter_app_firebase_login/scrapbook_widgets/scrapbook_title.dart';

import '../user_pages/profile_widget.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {

  //todo add third argument to addPost method below for url of image/video
  Future<void> addPost(String title, String desc) async {
    CollectionReference posts = FirebaseFirestore.instance.collection('posts');
    String userDocID = '';
    QuerySnapshot<Map<String, dynamic>> snap = await FirebaseFirestore
        .instance
        .collection("users")
        .where("uuid", isEqualTo: ProfilePage().getUuid() as String)
        .get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docList = snap.docs;
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in docList) {
      userDocID = doc.id;
    }
    DocumentReference userDocRef = FirebaseFirestore.instance.doc('/users/' + userDocID);
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


    //todo add the newly created scrapbook to the "scrapbook" collection in Firestore as well
  }




  @override
  Widget build(BuildContext context) {
    return Container(child: Column(
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
                 //print(ScrapbookTitle.scrapbookTitle);
                  //print(titleCaptionForPost.postTitle);
                  //print(titleCaptionForPost.postCaption);
                  //addPost(titleCaptionForPost().getPostTitle(), titleCaptionForPost().getPostCaption());
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
                child: Text("Create the scrapbook", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
          ],
        ),
      ],
    ));
  }
}
