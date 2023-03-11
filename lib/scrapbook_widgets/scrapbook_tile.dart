import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_firebase_login/post_widgets/expanded_post.dart';
import 'package:flutter_app_firebase_login/scrapbook_widgets/scrapbook.dart';
import 'package:flutter_app_firebase_login/scrapbook_widgets/scrapbook_posts_page.dart';
import 'package:provider/provider.dart';

import '../user_pages/profile_page.dart';
import '../util/user_model.dart';

class ScrapbookTile extends StatefulWidget {
  static String profileUrl = '';
  final Scrapbook scrapbook;


  ScrapbookTile(this.scrapbook);

  @override
  State<ScrapbookTile> createState() => _ScrapbookTileState();
}

class _ScrapbookTileState extends State<ScrapbookTile> {
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


  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) =>
                    ScrapbookPostsPage(scrapbook: this.widget.scrapbook)),
          );
        },
        child: Card(
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(30)),
          margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0),
          child: ListTile(
            leading: CircleAvatar(backgroundImage: NetworkImage(ScrapbookTile.profileUrl)),
            title: Text(widget.scrapbook.scrapbookTitle),
            subtitle: Text(widget.scrapbook.currentUsername),
            trailing: imageHandler(),
          ),
        ),
      ),
    );
  }
}