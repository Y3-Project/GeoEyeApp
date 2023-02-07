import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_firebase_login/post_widgets/post_tile.dart';
import 'package:flutter_app_firebase_login/user_pages/profile_widget.dart';
import 'package:provider/provider.dart';
import '../util/post.dart';

// TODO: make this a scrapbook list
class PostList extends StatefulWidget {
  const PostList({Key? key}) : super(key: key);

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  @override
  Widget build(BuildContext context) {
    final posts = Provider.of<List<Post>>(context);

    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index){
        return PostTile(posts[index]);
      },
    );
  }
}
