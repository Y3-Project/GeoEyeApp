import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_firebase_login/post_widgets/post_list.dart';
import 'package:flutter_app_firebase_login/user_pages/profile_widget.dart';
import 'package:provider/provider.dart';
import '../../util/post.dart';
import '../../util/util.dart';
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
      DocumentReference<Map<String, dynamic>> userRef = doc.get('user');

      // todo: make likes an array attribute
      return Post(
        timestamp: doc.data().toString().contains('timestamp') ? doc.get('timestamp') as Timestamp : Timestamp(0, 0),
        picture: doc.data().toString().contains('picture') ? doc.get('picture').toString() : '',
        video: doc.data().toString().contains('video') ? doc.get('video').toString() : '',
        //likes: doc.data().toString().contains('likes') ? doc.get('likes') as int : 0,
        likes: 0,
        //reported: doc.data().toString().contains('reported') ? doc.get('reported') as bool : false,
        reported: false,
        reportsNumber: 0,
        //reportsNumber: doc.data().toString().contains('reportsNumber') ? doc.get('reportsNumber') as int : 0,
        user: doc.data().toString().contains('user') ? userRef.path.toString(): '',
        text: doc.data().toString().contains('text') ? doc.get('text').toString() : '',
        title: doc.data().toString().contains('title') ? doc.get('title').toString() : '',
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
