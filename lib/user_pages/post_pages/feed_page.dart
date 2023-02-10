import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_firebase_login/post_widgets/post_list.dart';
import 'package:flutter_app_firebase_login/scrapbook_widgets/scrapbook_list.dart';
import 'package:flutter_app_firebase_login/user_pages/post_pages/choose_existing_scrapbook.dart';
import 'package:provider/provider.dart';
import '../../post_widgets/post.dart';
import 'package:popup_card/popup_card.dart';

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
      String userRefDoc = '/users/' + ref.id;
      return Post(
        timestamp: doc.get('timestamp') as Timestamp,
        picture: doc.get('picture').toString(),
        video: doc.get('video').toString(),
        likes: doc.get('likes'),
        reports: doc.get('reports'),
        user: userRefDoc,
        text: doc.get('text').toString(),
        title: doc.get('title').toString(),
        id: doc.id,
      );
    }).toList();
  }

  Widget popUpItemBody() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            onPressed: () {Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ChooseScrapbookPage(),
              ),
            );},
            child: const Text('CHOOSE THE SCRAPBOOK TO ADD A POST TO', style: TextStyle(color: Colors.green, fontSize: 14, fontWeight: FontWeight.bold)),
          ),
          const Divider(
            color: Colors.white,
            thickness: 0.1,
          ),
          const Divider(
            color: Colors.white,
            thickness: 0.1,
          ),
          TextButton(
            onPressed: () {},
            child: const Text('MAKE A NEW SCRAPBOOK', style: TextStyle(color: Colors.green, fontSize: 15, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Post>>.value(
      value: posts,
      initialData: [],
      // todo: display scrapbooks instead of posts
      child: Scaffold(
        body: PostList(),
        floatingActionButton: PopupItemLauncher(
          tag: 'test',
          child: Material(
            color: Colors.black,
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            child: const Icon(
              color: Colors.white,
              Icons.add_rounded,
              size: 60,
            ),
          ),
          popUp: PopUpItem(
            padding: EdgeInsets.all(8),
            color: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            elevation: 2,
            tag: 'test',
            child: popUpItemBody(),
          ),
        ),
      ),
    );
  }
}
