import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_firebase_login/post_widgets/post_list.dart';
import 'package:flutter_app_firebase_login/user_pages/profile_widget.dart';
import 'package:provider/provider.dart';
import '../../util/post.dart';

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
    return snapshot.docs.map((doc) {
      DocumentReference<Map<String, dynamic>> ref = doc.get('user');
      // String username = ref.get().then((value) => value.get('username')).then((value) => print(value.toString())).toString();
      // todo: add the remaining attributes from the server's post doc
      // Error received from other adding other attributes -> "Bad state: field does not exist within the DocumentSnapshotPlatform"
      return Post(
        timestamp: doc.get('timestamp') as Timestamp,
        picture: doc.get('picture').toString(),
        video: doc.get('video').toString(),
        likes: doc.get('likes'),
        reported: doc.get('reported') as bool,
        reportsNumber: doc.get('reportsNumber') as int,
        user: doc.get('user').toString(),
        text: doc.get('text').toString(),
        title: doc.get('title').toString(),
        id: doc.id,
      );
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
