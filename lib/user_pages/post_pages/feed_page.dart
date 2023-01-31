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
        //timestamp: doc.data().toString().contains('timestamp') ? doc.get('timestamp') as Timestamp : Timestamp(0, 0),
        timestamp: Timestamp(0, 0),
        picture: doc.data().toString().contains('picture') ? doc.get('picture').toString() : '',
        //video: doc.data().toString().contains('video') ? doc.get('video').toString() : '',
        video: '',
        likes: doc.get('likes'),
        //reported: doc.data().toString().contains('reported') ? doc.get('reported') as bool : false,
        reported: false,
        //reportsNumber: doc.data().toString().contains('reportsNumber') ? doc.get('reportsNumber') as int : 0,
        reportsNumber: 0,
        user: doc.data().toString().contains('user') ? doc.get('user').toString() : '',
        text: doc.data().toString().contains('text') ? doc.get('text').toString() : '',
        title: doc.data().toString().contains('title') ? doc.get('title').toString() : '',
        //id: doc.data().toString().contains('id') ? doc.get('id').toString() : '',
        id: ''
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
