import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_firebase_login/post_widgets/expanded_post.dart';
import 'package:flutter_app_firebase_login/util/scrapbook_util/get_marker.dart';
import '../scrapbook_widgets/scrapbook.dart';
import '../util/util.dart';
import 'post.dart';

class PostTile extends StatelessWidget {
  final Post post;
  String currentUUID = "";
  List<DocumentReference> userDocument = List.empty(growable: true);

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

  PostTile(this.post) {
    getCurrentUserReference();
  }

  Widget imageHandler() {
    if (post.picture != '') {
      return Image.network(post.picture);
    } else {
      return Image.asset('images/default_image.png');
    }
  }

  SnackBar reportedSnackBar = SnackBar(
    content: Text("Reported post to moderators"),
    duration: Duration(seconds: 2),
  );

  SnackBar deletedSnackBar = SnackBar(
    content: Text("Deleted post"),
    duration: Duration(seconds: 2),
  );

  showAlertDialog(BuildContext context) {
    Widget noReport = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop(); // dismiss dialog
      },
    );
    Widget yesReport = TextButton(
      child: Text("Yes"),
      onPressed: () {
        FirebaseFirestore.instance.doc(post.id.path).update({
          "reports": FieldValue.arrayUnion([getCurrentUserDocRef()])
        });

        ScaffoldMessenger.of(context).showSnackBar(reportedSnackBar);
        Navigator.of(context).pop(); // dismiss dialog
      },
    );

    AlertDialog reportDialog = AlertDialog(
      title: Text("Report Post"),
      content: Text("Are you sure you want to report this post?"),
      actions: [
        noReport,
        yesReport,
      ],
    );

    Widget yesDelete = TextButton(
      child: Text("Yes"),
      onPressed: () {
        FirebaseFirestore.instance.doc(post.id.path).delete();
        //TODO: Need to delete from storage as well
        Navigator.of(context).pop(); // dismiss dialog
        ScaffoldMessenger.of(context).showSnackBar(deletedSnackBar);
      },
    );

    Widget noDelete = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop(); // dismiss dialog
      },
    );

    AlertDialog deleteAlert = AlertDialog(
      title: Text("Delete Post"),
      content: Text("Are you sure you want to delete this post?"),
      actions: [
        noDelete,
        yesDelete,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        print("user id: " + post.user.id);
        print("current user id: " + userDocument[0].id);
        if (post.user.id == userDocument[0].id) {
          return deleteAlert;
        } else {
          return reportDialog;
        }
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
