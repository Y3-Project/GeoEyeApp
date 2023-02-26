import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_firebase_login/scrapbook_widgets/make_a_scrapbook.dart';
import 'package:flutter_app_firebase_login/scrapbook_widgets/scrapbook_list.dart';
import 'package:provider/provider.dart';
import 'package:popup_card/popup_card.dart';

import '../../scrapbook_widgets/scrapbook.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final CollectionReference scrapbookCollection =
      FirebaseFirestore.instance.collection('scrapbooks');

  Stream<List<Scrapbook>> get scrapbooks {
    return scrapbookCollection.snapshots().map(_scrapbookListFromSnapshot);
  }

  List<Scrapbook> _scrapbookListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Scrapbook(
        id: doc.id,
        creatorid: doc.get('creatorid').toString(),
        scrapbookTitle: doc.get('scrapbookTitle'),
        scrapbookThumbnail: doc.get('scrapbookThumbnail'),
        currentUsername: doc.get('currentUsername'),
        location: doc.get('location') as GeoPoint,
        timestamp: doc.get('timestamp') as Timestamp,
        public: doc.get('public'),
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
                builder: (context) => ScrapbookList(),
              ),
            );},
            child: const Text('CHOOSE THE SCRAPBOOK TO ADD A POST TO \n [MAY REMOVE THIS BUTTON LATER]', style: TextStyle(color: Colors.red, fontSize: 14, fontWeight: FontWeight.bold)),
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
            onPressed: () {Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => NewScrapbookPage(),
              ),
            );},
            child: const Text('MAKE A NEW SCRAPBOOK', style: TextStyle(color: Colors.green, fontSize: 15, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Scrapbook>>.value(
      value: scrapbooks,
      initialData: [],
      // todo: display scrapbooks instead of posts
      child: Scaffold(
        body: ScrapbookList(),
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
