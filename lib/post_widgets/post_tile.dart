import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/post.dart';

class PostTile extends StatelessWidget {
  final Post post;
  PostTile(this.post);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0),
        child: ListTile(
          leading: Image.network(post.thumbnail),
          title: Text(post.title),
          subtitle: Text(post.description),
        ),
      ),

    );
  }
}
