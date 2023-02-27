import 'package:cloud_firestore/cloud_firestore.dart';
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      // TODO: make cards redirect to expanded post
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ExpandedPostPage(post)),
          );
        },
        child: Card(
          margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0),
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
