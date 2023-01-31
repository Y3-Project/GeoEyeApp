import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../util/post.dart';

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
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0),
        child: ListTile(
          leading: imageHandler(),
          title: Text(post.title),
          subtitle: Text(post.text),
        ),
      ),
    );
  }
}
