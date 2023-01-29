import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app_firebase_login/util/post.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

Future<List<Post>> getPostsFromServer() async {
  // get post documents from firestore
  var postDocs = await FirebaseFirestore.instance
      .collection("posts")
      .orderBy("timestamp", descending: true)
      // group by location
      .limit(10)
      .get();

  // convert documents to Post objects
  List<Post> posts = [];
  for (var doc in postDocs.docs) {
    posts.add(Post.fromDocument(doc));
  }
  return posts;
}

class _FeedPageState extends State<FeedPage> {
  @override
  Widget build(BuildContext context) {
    // get list of posts from firestore via getPostsFromServer()
    // List<Post> posts = [];
    // getPostsFromServer().then((posts) => posts = posts);

    // todo: display posts

    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.fromLTRB(0, 5, 0, 10),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.white),
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Text('feed page placeholder'),
      ),
    );
  }
}
