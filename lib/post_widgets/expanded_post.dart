import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  SnackBar likedSnackBar = SnackBar(
    content: Text("You liked this post"),
    duration: Duration(seconds: 1),
  );

  SnackBar reportedSnackBar = SnackBar(
    content: Text("Reported comment to moderators"),
    duration: Duration(seconds: 2),
  );

  TextEditingController commentBox = new TextEditingController();

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
    for (int i = 0; i < _snapshots.length; i++) {
      comments.add(new Comment(
          content: _snapshots[i].get('content'),
          post: _snapshots[i].get('post').toString(),
          reports: _snapshots[i].get('reports'),
          user: _snapshots[i].get('user').toString(),
          timestamp: _snapshots[i].get('timestamp'),
          id: _snapshots[i].id));
    }
  }

  /* TODO: this doesnt work idk why
  String getUsername(String documentReference) {
    RegExp pattern = new RegExp('users\/([a-zA-Z0-9]+)');
    String? match = pattern.stringMatch(documentReference)?.split("/")?.last;

    print(match);

    if (match != null) {
      // get username from user document
      FirebaseFirestore.instance
          .collection("users")
          .doc("general")
          .get()
          .then((value) {
        return value.get("username") == null ? "Unknown user" : value.get("username");
      });
    }
    return "unknown user";
  }
   */

  String getLikesString(List<dynamic> likes) {
    String heart = "❤️ ";
    if (likes.length == 0) {
      return heart + "Be the first to like this post!";
    } else if (likes.length == 1) {
      return heart + "Liked by " + likes[0].toString();
    } else if (likes.length == 2) {
      return heart +
          "Liked by " +
          likes[0].toString() +
          " and " +
          likes[1].toString();
    } else if (likes.length == 3) {
      return heart +
          "Liked by " +
          likes[0].toString() +
          ", " +
          likes[1].toString() +
          " and " +
          likes[2].toString();
    } else {
      return heart +
          "Liked by " +
          likes[0].toString() +
          ", " +
          likes[1].toString() +
          " and " +
          (likes.length - 2).toString() +
          " others";
    }
  }

  showAlertDialog(BuildContext context) {
    Widget cancelBtn = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop(); // dismiss dialog
      },
    );
    Widget yesBtn = TextButton(
      child: Text("Yes"),
      onPressed: () {
        // todo: report the comment
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
                  print('double tapped'),
                  ScaffoldMessenger.of(context).showSnackBar(likedSnackBar)
                },
                child: Image.network(widget.post.picture == ""
                    ? "https://www.myutilitygenius.co.uk/assets/images/blogs/default-image.jpg"
                    : widget.post.picture),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: InkWell(
                  onTap: () => {
                    print('clicked like'),
                    ScaffoldMessenger.of(context).showSnackBar(likedSnackBar)
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    height: 40,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(getLikesString(widget.post.likes),
                          style: TextStyle(fontSize: 20)),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                    comments.length > 0
                        ? "Comments (" + comments.length.toString() + "):"
                        : "",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              // there is a better way to do this proposed by jacob but i couldnt get it working
              for (int i = 0; i < comments.length; i++)
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => print('clicked on comment: ' + i.toString()),
                    // go to user profile
                    onLongPress: () {
                      print('long pressed comment: ' + i.toString());
                      showAlertDialog(context);
                    },
                    // report comment (maybe open a menu first?)
                    child: Container(
                      height: 50,
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                              "user" +
                                  i.toString() + //getUsername(comments[i].user).toString() +
                                  ": " +
                                  comments[i].content,
                              style: TextStyle(fontSize: 20))),
                    ),
                  ),
                ),
              TextField(
                onEditingComplete: () {
                  // todo: add new document to postComments collection

                  // close keyboard
                  FocusScope.of(context).unfocus();
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
