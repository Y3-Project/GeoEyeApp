import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_firebase_login/post_widgets/expanded_post.dart';
import 'package:flutter_app_firebase_login/scrapbook_widgets/scrapbook.dart';
import 'package:flutter_app_firebase_login/scrapbook_widgets/scrapbook_posts_page.dart';

class ScrapbookTile extends StatelessWidget {
  final Scrapbook scrapbook;

  ScrapbookTile(this.scrapbook);

  Widget imageHandler() {
    if (scrapbook.scrapbookThumbnail != '') {
      return Image.network(scrapbook.scrapbookThumbnail);
    } else {
      // default image file from images/default_image.png
      return Image.asset('images/default_image.png');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      // TODO: make cards redirect to expanded post
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => ScrapbookPostsPage(scrapbook: this.scrapbook)),
          );
        },
        child: Card(
          margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0),
          child: ListTile(
            leading: imageHandler(),
            title: Text(scrapbook.scrapbookTitle),
            subtitle: Text(scrapbook.currentUsername),
          ),
        ),
      ),
    );
  }
}
