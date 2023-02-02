import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_firebase_login/user_pages/profile_widget.dart';

import '../../util/post.dart';

class CreatePostPage extends StatefulWidget {
  // TODO: we will also need the currently logged in user
  const CreatePostPage({Key? key}) : super(key: key);

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {

  final titleTextController = TextEditingController();
  final descTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {


    Future<void> addPost(String title, String desc) async {
      CollectionReference posts = FirebaseFirestore.instance.collection('posts');
      String userDocID = '';
      QuerySnapshot<Map<String, dynamic>> snap = await FirebaseFirestore
          .instance
          .collection("users")
          .where("uuid", isEqualTo: ProfileWidget().getUuid() as String)
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
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 64,
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          "Create Post",
          style: TextStyle(fontSize: 25),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
            child: TextField(
              controller: titleTextController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Post Title'),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 50),
            child: TextField(
              controller: descTextController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter a caption for the post...'),
            ),
          ),
          Container(child: Image.asset('images/add_img.png')),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => Colors.black),
                      textStyle: MaterialStateTextStyle.resolveWith(
                          (states) => TextStyle(color: Colors.white))),
                  onPressed: () {
                    // TODO: Implement uploading pictures and videos with a post
                    addPost(titleTextController.text, descTextController.text);
                    titleTextController.clear();
                    descTextController.clear();
                  },
                  child: Text("Post")),
            ],
          ),
        ],
      ),
    );
  }
}
