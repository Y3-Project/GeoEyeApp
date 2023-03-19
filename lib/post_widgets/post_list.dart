import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_firebase_login/post_widgets/post_tile.dart';
import 'package:flutter_app_firebase_login/scrapbook_widgets/scrapbook_post.dart';
import 'package:provider/provider.dart';

import '../scrapbook_widgets/scrapbook.dart';
import 'post.dart';

class PostList extends StatefulWidget {
  final Scrapbook scrapbook;

  const PostList({required this.scrapbook});

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  List<Post> posts = [];

  @override
  Widget build(BuildContext context) {
    final scrapbookPosts = Provider.of<List<ScrapbookPost>>(context);

    Future<List<Post>> getPosts(List<ScrapbookPost> scrapbookPosts) async {
      List<Post> tempPosts = [];

      for (int i = 0; i < scrapbookPosts.length; i++) {
        DocumentSnapshot currScrapbook =
            await scrapbookPosts[i].scrapbookRef.get();
        if (currScrapbook.id == widget.scrapbook.id) {
          DocumentSnapshot postSnap = await scrapbookPosts[i].postRef.get();
          Post currPost = Post.fromDocument(postSnap);
          if (currPost.reports.isEmpty) {
            tempPosts.add(currPost);
          }
        }
      }
      return tempPosts;
    }

    ;

    getPosts(scrapbookPosts).then((value) {
      posts = value;
      setState(() {});
    });

    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return PostTile(posts[index]);
      },
    );
  }
}
