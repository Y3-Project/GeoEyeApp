import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_firebase_login/user_pages/profile_widget.dart';
import 'package:firebase_core/firebase_core.dart' as fire_core;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';


/*
NOT
IN
USE
CURRENTLY
GO
TO
add_post.dart
 */



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
    }


    Future<File> pickImage(ImageSource imageSource) async {
      XFile? imgXFile = await ImagePicker().pickImage(source: imageSource);
      File imgFile = File('');
      if(imgXFile != null) {
        imgFile = File(imgXFile.path);
      }
      final String path = (await getApplicationDocumentsDirectory()).absolute.path;
      final finalImage = await imgFile.copy('$path/postPic.png');
      return finalImage;
    }

    Future<String> uploadPicture(File picture) async{
      final storageRef = FirebaseStorage.instance.ref();
      final imgRef = storageRef.child('images/img.png');
      String picStoragePath = '';

      try {
        picStoragePath = await imgRef.putFile(picture).snapshot.ref.getDownloadURL().toString();
      } on fire_core.FirebaseException catch (e) {
        print(e.toString());
      }
      print(picStoragePath);
      return picStoragePath;
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
                  onPressed: () async {
                    // TODO: Implement uploading pictures and videos with a post
                    addPost(titleTextController.text, descTextController.text);
                    titleTextController.clear();
                    descTextController.clear();
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
                  child: Text("Post")),
            ],
          ),
        ],
      ),
    );
  }
}
