import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_firebase_login/post_widgets/post_list.dart';
import 'package:flutter_app_firebase_login/scrapbook_widgets/scrapbook.dart';
import 'package:flutter_app_firebase_login/scrapbook_widgets/scrapbook_post.dart';
import 'package:flutter_app_firebase_login/user_pages/post_pages/feed_page.dart';
import 'package:flutter_app_firebase_login/user_pages/profile_page.dart';
import 'package:flutter_app_firebase_login/util/scrapbook_util/get_marker.dart';
import 'package:flutter_app_firebase_login/util/scrapbook_util/get_scrapbook_posts.dart';
import 'package:provider/provider.dart';

import '../user_pages/main_page.dart';

class ScrapbookPostsPage extends StatefulWidget {
  final Scrapbook scrapbook;

  const ScrapbookPostsPage({required this.scrapbook});

  @override
  State<ScrapbookPostsPage> createState() => _ScrapbookPostsPageState();
}

class _ScrapbookPostsPageState extends State<ScrapbookPostsPage> {
  Future<void> deleteScrapbook() async {
    List<DocumentReference> scrapbookPostsRefs =
        await getScrapbookPostsFromScrapbook(widget.scrapbook);

    final storageRef = FirebaseStorage.instance.ref();

    //Delete all the scrapbook's /posts/ docs in firestore database
    for (DocumentReference scrapbookPostRef in scrapbookPostsRefs) {
      DocumentReference postRef =
          (await scrapbookPostRef.get()).get("post") as DocumentReference;
      DocumentSnapshot postDoc = await postRef.get();
      String postStoragePath = postDoc.get('postStoragePath');
      //Delete scrapbook in firebase storage for both images and videos
      await storageRef
          .child(postStoragePath)
          .delete()
          .catchError((error) => debugPrint(error.toString()));
      await postRef
          .delete()
          .catchError((error) => debugPrint(error.toString()));
    }

    //Delete all scrapbook's /scrapbookPost/ docs in firestore database
    for (DocumentReference scrapbookPostRef in scrapbookPostsRefs) {
      await scrapbookPostRef
          .delete()
          .catchError((error) => debugPrint(error.toString()));
    }

    //Delete scrapbook's /marker/ doc in firestore database
    List<DocumentReference> markerRefs =
        await getMarkerFromScrapbook(widget.scrapbook);
    for (DocumentReference markerRef in markerRefs) {
      await markerRef
          .delete()
          .catchError((error) => debugPrint(error.toString()));
    }

    //Delete Scrapbook thumbnail
    await storageRef
        .child(widget.scrapbook.thumbnailStoragePath)
        .delete()
        .catchError((error) => debugPrint(error.toString()));

    //Delete scrapbook's /scrapbook/ doc in firestore database
    DocumentReference scrapbookRef =
        FirebaseFirestore.instance.doc("/scrapbooks/" + widget.scrapbook.id);
    await scrapbookRef
        .delete()
        .catchError((error) => debugPrint(error.toString()));
  }

  final CollectionReference scrapbookPostCollection =
      FirebaseFirestore.instance.collection('scrapbookPosts');

  Stream<List<ScrapbookPost>> get scrapbookPosts {
    return scrapbookPostCollection
        .snapshots()
        .map(_scrapbookPostListFromSnapshot);
  }

  List<ScrapbookPost> _scrapbookPostListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return ScrapbookPost(
        postRef: doc.get('post') as DocumentReference,
        scrapbookRef: doc.get('scrapbook') as DocumentReference,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<ScrapbookPost>>.value(
      value: scrapbookPosts,
      initialData: [],
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => MainUserPage()),
              );
            },
          ),
          toolbarHeight: 64,
          backgroundColor: Colors.black,
          centerTitle: true,
          title: Text(
            widget.scrapbook.scrapbookTitle,
            style: TextStyle(fontSize: 25),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            content: Text(
                                "Are you sure you want to delete this scrapbook?"),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    deleteScrapbook().then((value) =>
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MainUserPage())));
                                  },
                                  child: Text("Yes")),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Cancel"))
                            ],
                          ));
                },
                icon: const Icon(Icons.delete))
          ],
        ),
        body: PostList(scrapbook: widget.scrapbook),
      ),
    );
  }
}
