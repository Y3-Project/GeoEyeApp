import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_firebase_login/post_widgets/post_list.dart';
import 'package:flutter_app_firebase_login/scrapbook_widgets/scrapbook.dart';
import 'package:flutter_app_firebase_login/scrapbook_widgets/scrapbook_post.dart';
import 'package:provider/provider.dart';

class ScrapbookPostsPage extends StatefulWidget {
  final Scrapbook scrapbook;
  const ScrapbookPostsPage({required this.scrapbook});

  @override
  State<ScrapbookPostsPage> createState() => _ScrapbookPostsPageState();
}

class _ScrapbookPostsPageState extends State<ScrapbookPostsPage> {
  final CollectionReference scrapbookPostCollection =
  FirebaseFirestore.instance.collection('scrapbookPosts');

  Stream<List<ScrapbookPost>> get scrapbookPosts {
    return scrapbookPostCollection.snapshots().map(_scrapbookPostListFromSnapshot);
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
          toolbarHeight: 64,
          backgroundColor: Colors.black,
          centerTitle: true,
          title: Text(
            widget.scrapbook.scrapbookTitle,
            style: TextStyle(fontSize: 25),
          ),
        ),
        body: PostList(scrapbook: widget.scrapbook),
      ),
    );
  }
}
