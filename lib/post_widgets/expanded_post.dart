import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_firebase_login/post_widgets/post.dart';
import 'package:flutter_app_firebase_login/scrapbook_widgets/scrapbook_posts_page.dart';

import '../scrapbook_widgets/scrapbook.dart';
import '../util/comment.dart';
import '../util/getScrapbookFromPost.dart';

class ExpandedPostPage extends StatefulWidget {
  Post post;

  ExpandedPostPage(this.post);

  @override
  State<ExpandedPostPage> createState() => _ExpandedPostPageState();
}

class _ExpandedPostPageState extends State<ExpandedPostPage> {
  var _querySnapshot;
  var _display = List.empty(growable: true);
  var _snapshots = List.empty(growable: true);

  var comments = List.empty(growable: true);

  @override
  void initState() {
    _querySnapshot = FirebaseFirestore.instance
        .collection("postComments")
        .snapshots()
        .listen((snapshot) {
      setState(() {
        _display.clear();
        _snapshots.clear();
        _snapshots.addAll(snapshot.docs);
        for (int i = 0; i < _snapshots.length; i++) {
          List<dynamic> reports = _snapshots[i].get("reports");
          if (reports.length != 0) {
            continue;
          }
          initDisplay(i);
        }
      });
    });
    super.initState();
  }

  Future<void> initDisplay(int i) async {
    // print("comments: ${_snapshots[i].data().toString()}");
    // _display.add(await );

    // convert snapshot data to array of comments
    for (int i = 0; i < _snapshots.length; i++) {
      comments.add(new Comment(
        content: _snapshots[i].get('content'),
        post: _snapshots[i].get('post'),
        reports: _snapshots[i].get('reports'),
        user: _snapshots[i].get('user'),
      ));
    }

    print("comments: ${comments.toString()}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            getScrapbook(widget.post).then((scrapbook) {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) =>
                        ScrapbookPostsPage(scrapbook: scrapbook)),
              );
            });
          },
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          widget.post.title,
          style: TextStyle(fontSize: 25),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(widget.post.picture == ""
                  ? "https://www.myutilitygenius.co.uk/assets/images/blogs/default-image.jpg"
                  : widget.post.picture),
              Text(widget.post.likes.length.toString() + " likes",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              for (int i = 0; i < comments.length; i++)
                Text(comments[i].content, style: TextStyle(fontSize: 20)),
            ],
          ),
        ),
      ),
    );
  }
}
