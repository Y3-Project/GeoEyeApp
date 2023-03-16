import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_firebase_login/comment_widgets/comment_tile.dart';
import 'package:flutter_app_firebase_login/post_widgets/post.dart';
import 'package:flutter_app_firebase_login/scrapbook_widgets/scrapbook_posts_page.dart';

import '../util/comment.dart';
import '../util/getScrapbookFromPost.dart';
import '../util/util.dart';

class ExpandedPostPage extends StatefulWidget {
  late Post post;

  ExpandedPostPage(Post post) {
    this.post = post;
  }

  @override
  State<ExpandedPostPage> createState() => _ExpandedPostPageState();
}

class _ExpandedPostPageState extends State<ExpandedPostPage> {
  late StreamSubscription _querySnapshot;
  List<CommentTile> _displayComments = List.empty(growable: true);
  List<QueryDocumentSnapshot> _snapshots = List.empty(growable: true);
  String currentUUID = "";
  // this is really annoying
  // basically you can declare a document refence object normally
  // so I'm doing this lmao
  // this list will only ever have one item!!
  List<DocumentReference> userDocument = List.empty(growable: true);
  List<Comment> comments = List.empty(growable: true);

  SnackBar likedSnackBar = SnackBar(
    content: Text("You liked this post"),
    duration: Duration(seconds: 1),
  );

  SnackBar reportedSnackBar = SnackBar(
    content: Text("Reported comment to moderators"),
    duration: Duration(seconds: 2),
  );

  TextEditingController commentBox = new TextEditingController();

  Future<void> loadComments() async {
    _querySnapshot = FirebaseFirestore.instance
        .collection("postComments")
        .snapshots()
        .listen((snapshot) {
      setState(() {
        _displayComments.clear();
        _snapshots.clear();
        _snapshots.addAll(snapshot.docs);
        for (int i = 0; i < _snapshots.length; i++) {
          List<dynamic> reports = _snapshots[i].get("reports");
          if (reports.length != 0) {
            continue;
          }
          if (_snapshots[i].get("post") == this.widget.post.id) {
            initComments(i);
          }
        }
      });
    });
  }

  Future<void> getCurrentUserReference() async {
    currentUUID = FirebaseAuth.instance.currentUser!.uid;
    print("current UUID: " + currentUUID);
    await FirebaseFirestore.instance
        .collection("users")
        .where("uuid", isEqualTo: currentUUID)
        .snapshots()
        .listen((event) {
      for (var doc in event.docs) {
        print(doc.id);
        userDocument.add(doc.reference);
      }
    });
  }

  @override
  void initState() {
    getCurrentUserReference();
    loadComments();
    super.initState();
  }

  Future<void> initComments(int i) async {
    _displayComments.add(CommentTile(Comment.fromDocument(_snapshots[i])));
  }

  String getLikesString(List<dynamic> likes) {
    var usernames = List.empty(growable: true);
    for (int i = 0; i < likes.length; i++) {
      usernames.add(getUsername(likes[i]));
    }

    String heart = "❤️ ";
    if (usernames.length == 0) {
      return heart + "Be the first to like this post!";
    } else if (usernames.length == 1) {
      return heart + "Liked by " + usernames[0].toString();
    } else if (usernames.length == 2) {
      return heart +
          "Liked by " +
          usernames[0].toString() +
          " and " +
          usernames[1].toString();
    } else if (usernames.length == 3) {
      return heart +
          "Liked by " +
          usernames[0].toString() +
          ", " +
          usernames[1].toString() +
          " and " +
          usernames[2].toString();
    } else {
      return heart +
          "Liked by " +
          usernames[0].toString() +
          ", " +
          usernames[1].toString() +
          " and " +
          (usernames.length - 2).toString() +
          " others";
    }
  }

  reportDialog(BuildContext context, Comment comment) {
    Widget cancelBtn = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop(); // dismiss dialog
      },
    );
    Widget yesBtn = TextButton(
      child: Text("Yes"),
      onPressed: () {
        FirebaseFirestore.instance.doc(comment.id.path).update({
          "reports": FieldValue.arrayUnion([getCurrentUserDocRef()])
        });

        ScaffoldMessenger.of(context).showSnackBar(reportedSnackBar);
        Navigator.of(context).pop(); // dismiss dialog
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Report Comment"),
      content: Text("Are you sure you want to report this comment?"),
      actions: [
        cancelBtn,
        yesBtn,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
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
              InkWell(
                onDoubleTap: () => {
                  likePost(this.widget.post.id),
                  ScaffoldMessenger.of(context).showSnackBar(likedSnackBar)
                },
                // TODO, might be a video
                child: Image.network(widget.post.picture == ""
                    ? "https://www.myutilitygenius.co.uk/assets/images/blogs/default-image.jpg"
                    : widget.post.picture),
              ),
              // LIKES / LIKING
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: InkWell(
                  onTap: () => {
                    likePost(this.widget.post.id),
                    ScaffoldMessenger.of(context).showSnackBar(likedSnackBar)
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    height: 60,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(getLikesString(widget.post.likes),
                          style: TextStyle(fontSize: 20)),
                    ),
                  ),
                ),
              ),
              // START OF COMMENT SECTION
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Comments (${_displayComments.length}):",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              // LOOPING THROUGH ALL COMMENTS
              for (var commentTile in _displayComments)
                Container(
                  height: 80,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () => {
                        // todo: here we want to go to the profile of the user who authored this comment
                      },
                      onLongPress: () {
                        reportDialog(context, commentTile.getComment());
                      },
                      child: Container(
                          height: 50,
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: commentTile)),
                    ),
                  ),
                ),
              // ADDING COMMENT
              TextField(
                onEditingComplete: () {
                  addComment(widget.post.id, commentBox.text, userDocument[0]);
                  FocusScope.of(context).unfocus(); // close the keyboard
                  commentBox.clear(); // clear the commentBox
                },
                controller: commentBox,
                maxLength: 40,
                style: TextStyle(fontSize: 20),
                decoration: InputDecoration(
                    hintStyle: TextStyle(fontSize: 18),
                    hintText: 'Enter a comment...',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              )
            ],
          ),
        ),
      ),
    );
  }
}
