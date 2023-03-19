import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_firebase_login/comment_widgets/comment_tile.dart';
import 'package:flutter_app_firebase_login/media_widgets/video_player_widget.dart';
import 'package:flutter_app_firebase_login/post_widgets/post.dart';
import 'package:flutter_app_firebase_login/scrapbook_widgets/scrapbook_posts_page.dart';

import '../util/comment.dart';
import '../util/scrapbook_util/getScrapbookFromPost.dart';
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
  bool liked =
      false; // a bandage solution to the problem of the like button not updating

  // this is really annoying
  // basically you can declare a document refence object normally
  // so I'm doing this lmao
  // this list will only ever have one item!!
  List<DocumentReference> userDocument = List.empty(growable: true);
  List<Comment> comments = List.empty(growable: true);
  List<dynamic> likesList = List.empty(growable: true); // will be list of likes
  int l = 0; // temp likes variable

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
    await FirebaseFirestore.instance
        .collection("users")
        .where("uuid", isEqualTo: currentUUID)
        .snapshots()
        .listen((event) {
      for (var doc in event.docs) {
        userDocument.add(doc.reference);
      }
    });
  }

  Future<void> loadLikes() async {
    FirebaseFirestore.instance
        .doc(this.widget.post.id.path)
        .snapshots()
        .listen((event) {
      for (DocumentReference doc in event.get("likes")) {
        FirebaseFirestore.instance.doc(doc.path).snapshots().listen((event) {
          likesList.add(event.get("username"));
        });
      }
    });
  }

  @override
  void initState() {
    getCurrentUserReference();
    loadComments();
    loadLikes();
    super.initState();
  }

  Future<void> initComments(int i) async {
    _displayComments.add(CommentTile(Comment.fromDocument(_snapshots[i])));
  }

  String getLikesString(List<dynamic> likes) {
    List<dynamic> likesUsernames = likesList;

    String heart = "❤️ ";
    if (l == 0) {
      return heart + "Be the first to like this post!";
    } else {
      return heart + l.toString();
    }

    if (likesUsernames.length == 0) {
      return heart + "Be the first to like this post!";
    } else if (likesUsernames.length == 1) {
      return heart + "Liked by " + likes[0].toString();
    } else if (likesUsernames.length == 2) {
      return heart +
          "Liked by " +
          likesUsernames[0].toString() +
          " and " +
          likesUsernames[1].toString();
    } else if (likesUsernames.length == 3) {
      return heart +
          "Liked by " +
          likesUsernames[0].toString() +
          ", " +
          likesUsernames[1].toString() +
          " and " +
          likesUsernames[2].toString();
    } else {
      return heart +
          "Liked by " +
          likesUsernames[0].toString() +
          ", " +
          likesUsernames[1].toString() +
          " and " +
          (likesUsernames.length - 2).toString() +
          " others";
    }
  }

  SnackBar deletedSnackBar = SnackBar(
    content: Text("Deleted post"),
    duration: Duration(seconds: 2),
  );

  reportDialog(BuildContext context, Comment comment) {
    Widget noReport = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop(); // dismiss dialog
      },
    );
    Widget yesReport = TextButton(
      child: Text("Yes"),
      onPressed: () {
        FirebaseFirestore.instance
            .doc(comment.id.path)
            .update({"reports": FieldValue.arrayUnion(userDocument)});

        ScaffoldMessenger.of(context).showSnackBar(reportedSnackBar);
        Navigator.of(context).pop(); // dismiss dialog
      },
    );

    AlertDialog reportDialog = AlertDialog(
      title: Text("Report Comment"),
      content: Text("Are you sure you want to report this comment?"),
      actions: [
        noReport,
        yesReport,
      ],
    );

    Widget noDelete = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop(); // dismiss dialog
      },
    );

    Widget yesDelete = TextButton(
      child: Text("Yes"),
      onPressed: () {
        FirebaseFirestore.instance.doc(comment.id.path).delete();
        Navigator.of(context).pop(); // dismiss dialog
        ScaffoldMessenger.of(context).showSnackBar(deletedSnackBar);
      },
    );

    AlertDialog deleteDialog = AlertDialog(
      title: Text("Delete Comment"),
      content: Text("Are you sure you want to delete this comment?"),
      actions: [
        noDelete,
        yesDelete,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        if (comment.user.id == userDocument[0].id) {
          return deleteDialog;
        } else {
          return reportDialog;
        }
      },
    );
  }

  Widget mediaWidgetPicker() {
    Widget pickedMediaWidget = new Image.network("");
    if (widget.post.picture != "") {
      pickedMediaWidget = Image.network(widget.post.picture == ""
          ? "https://www.myutilitygenius.co.uk/assets/images/blogs/default-image.jpg"
          : widget.post.picture);
    } else {
      pickedMediaWidget = new VideoPlayerScreen(videoUrl: widget.post.video);
    }
    return pickedMediaWidget;
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
                  if (!liked)
                    {
                      liked = true,
                      likePost(this.widget.post.id, userDocument),
                      ScaffoldMessenger.of(context).showSnackBar(likedSnackBar)
                    }
                  else
                    {
                      liked = false,
                      removeLike(this.widget.post.id, userDocument),
                    }
                },
                // TODO, might be a video
                child: mediaWidgetPicker(),
              ),
              // LIKES / LIKING
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: InkWell(
                  onTap: () => {
                    if (!liked)
                      {
                        liked = true,
                        likePost(this.widget.post.id, userDocument),
                        ScaffoldMessenger.of(context)
                            .showSnackBar(likedSnackBar),
                        setState(() {
                          // add use to likesList
                          likesList.add(getCurrentUserReference());
                          l = l + 1;
                        })
                      }
                    else
                      {
                        liked = false,
                        removeLike(this.widget.post.id, userDocument),
                      }
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
