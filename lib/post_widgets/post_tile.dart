import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_firebase_login/post_widgets/expanded_post.dart';
import 'package:flutter_app_firebase_login/util/getScrapbookFromPost.dart';
import '../scrapbook_widgets/scrapbook.dart';
import 'post.dart';

// TODO: make another file called scrapbook_tile.dart
class PostTile extends StatelessWidget {
  final Post post;

  PostTile(this.post);

  Widget imageHandler() {
    if (post.picture != '') {
      return Image.network(post.picture);
    } else {
      // default image file from images/default_image.png
      return Image.asset('images/default_image.png');
    }
  }

  SnackBar reportedSnackBar = SnackBar(
    content: Text("Reported post to moderators"),
    duration: Duration(seconds: 2),
  );

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
        User? user = FirebaseAuth.instance.currentUser;
        FirebaseFirestore.instance.collection("posts").doc(post.id).update({
          "reports": FieldValue.arrayUnion([user!.uid])
        });

        ScaffoldMessenger.of(context).showSnackBar(reportedSnackBar);
        Navigator.of(context).pop(); // dismiss dialog
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Report Post"),
      content: Text("Are you sure you want to report this post?"),
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
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ExpandedPostPage(post)),
            );
          },
          onLongPress: () {
            showAlertDialog(context);
          },
          child: ListTile(
            leading: imageHandler(),
            title: Text(post.title),
            subtitle: Text(post.text),
          ),
        ),
      ),
    );
  }
}
