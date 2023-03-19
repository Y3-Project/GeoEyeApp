import 'package:cloud_firestore/cloud_firestore.dart';
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
  bool doesPostBelongToUser() {
    print("current user: " + getCurrentUsername());
    print("post user: " + widget.scrapbook.currentUsername);
    return widget.scrapbook.currentUsername == getCurrentUsername();
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
        FirebaseFirestore.instance.doc('/posts/' + widget.scrapbook.id).update({
          "reports": FieldValue.arrayUnion([getCurrentUserDocRef()])
        });

        ScaffoldMessenger.of(context).showSnackBar(reportedSnackBar);
        Navigator.of(context).pop(); // dismiss dialog
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text(doesPostBelongToUser() ? "Delete Post" : "Report Post"),
      content: Text(
          doesPostBelongToUser()
              ? "Are you sure you want to delete this post?"
              : "Are you sure you want to report this post?",
          style: TextStyle(fontSize: 16, color: Colors.red)),
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
