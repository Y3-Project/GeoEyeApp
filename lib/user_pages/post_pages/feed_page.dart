import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_firebase_login/post_widgets/post_list.dart';
import 'package:flutter_app_firebase_login/user_pages/profile_widget.dart';
import 'package:provider/provider.dart';

import '../../models/post.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final CollectionReference postCollection =
      FirebaseFirestore.instance.collection('posts');

  Stream<List<Post>> get posts {
    return postCollection.snapshots().map(_postListFromSnapshot);
  }

  List<Post> _postListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((e) {
      DocumentReference<Map<String, dynamic>> ref = e.get('user');
      String username = ref.get().then((value) => value.get('username')).then((value) => print(value.toString())).toString();

      return Post(e.get('picture').toString(), e.get('title').toString(),
          e.get('text').toString(), username);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Post>>.value(
      value: posts,
      initialData: [],
      // todo: display scrapbooks instead of posts
      child: Scaffold(body: PostList()),
    );
  }
}
