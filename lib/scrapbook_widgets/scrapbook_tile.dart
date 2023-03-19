import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_firebase_login/scrapbook_widgets/scrapbook.dart';
import 'package:flutter_app_firebase_login/scrapbook_widgets/scrapbook_posts_page.dart';

import '../user_pages/profile_page.dart';
import '../util/util.dart';

class ScrapbookTile extends StatefulWidget {
  static String profileUrl = '';
  final Scrapbook scrapbook;

  ScrapbookTile(this.scrapbook);

  @override
  State<ScrapbookTile> createState() => _ScrapbookTileState();
}

class _ScrapbookTileState extends State<ScrapbookTile> {
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

  void getProfilePic() async {
    QuerySnapshot<Map<String, dynamic>> snap = await FirebaseFirestore.instance
        .collection("users")
        .where("uuid", isEqualTo: ProfilePage().getUuid() as String)
        .get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docList = snap.docs;
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in docList) {
      ScrapbookTile.profileUrl = await doc['profilePicture'];
    }
  }

  Widget imageHandler() {
    if (widget.scrapbook.scrapbookThumbnail != '') {
      return Image.network(widget.scrapbook.scrapbookThumbnail);
    } else {
      // default image file from images/default_image.png
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
        FirebaseFirestore.instance.doc('/posts/' + widget.scrapbook.id).update({
          "reports": FieldValue.arrayUnion([getCurrentUserDocRef()])
        });

        ScaffoldMessenger.of(context).showSnackBar(reportedSnackBar);
        Navigator.of(context).pop(); // dismiss dialog
      },
    );

    AlertDialog reportAlert = AlertDialog(
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
        FirebaseFirestore.instance.doc('/posts/' + widget.scrapbook.id).delete();
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
        print(widget.scrapbook.creatorid);
        print('/' + userDocument[0].path);
        if (widget.scrapbook.creatorid == '/' + userDocument[0].path) {
          return deleteAlert;
        } else {
          return reportAlert;
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getCurrentUserReference();
    getProfilePic();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        shape:
            ContinuousRectangleBorder(borderRadius: BorderRadius.circular(30)),
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onLongPress: () {
            showAlertDialog(context);
          },
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) =>
                      ScrapbookPostsPage(scrapbook: this.widget.scrapbook)),
            );
          },
          child: ListTile(
            leading: CircleAvatar(
                backgroundImage: ScrapbookTile.profileUrl == ''
                    ? Image(
                        image: AssetImage('images/default_avatar.png'),
                      ).image
                    : NetworkImage(ScrapbookTile.profileUrl)),
            title: Text(widget.scrapbook.scrapbookTitle),
            subtitle: Text(widget.scrapbook.currentUsername),
            trailing: imageHandler(),
          ),
        ),
      ),
    );
  }
}
