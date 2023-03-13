import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_firebase_login/scrapbook_widgets/scrapbook.dart';
import 'package:flutter_app_firebase_login/scrapbook_widgets/scrapbook_tile.dart';
import '../user_pages/profile_page.dart';

class CurrentUserScrapbookList extends StatefulWidget {
  const CurrentUserScrapbookList({Key? key}) : super(key: key);

  static String currentUsername = '';
  static List<Scrapbook> currentScrapbooks = [];

  @override
  State<CurrentUserScrapbookList> createState() =>
      _CurrentUserScrapbookListState();
}

class _CurrentUserScrapbookListState extends State<CurrentUserScrapbookList> {
  Future<List<Scrapbook>> getCurrentUserScrapbooks() async {
    List<Scrapbook> currentUserScrapbooks = [];

    //to get the current username
    QuerySnapshot<Map<String, dynamic>> snap = await FirebaseFirestore.instance
        .collection("users")
        .where("uuid", isEqualTo: ProfilePage().getUuid() as String)
        .get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docList = snap.docs;
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in docList) {
      CurrentUserScrapbookList.currentUsername = await doc['username'];
    }

    QuerySnapshot<Map<String, dynamic>> snap2 = await FirebaseFirestore.instance
        .collection("scrapbooks")
        .where("currentUsername",
            isEqualTo: await CurrentUserScrapbookList.currentUsername)
        .get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docList2 = snap2.docs;

    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in docList2) {
      currentUserScrapbooks.add(Scrapbook(
          id: doc.id,
          creatorid: doc['creatorid'].toString(),
          scrapbookTitle: doc['scrapbookTitle'],
          scrapbookThumbnail: doc['scrapbookThumbnail'],
          currentUsername: doc['currentUsername'],
          location: doc['location'],
          timestamp: doc['timestamp'],
          public: doc['public']));
    }

    return await currentUserScrapbooks;
  }
  

  @override
  Widget build(BuildContext context) {

    getCurrentUserScrapbooks().then((value) => CurrentUserScrapbookList.currentScrapbooks = value);

    return Scaffold(
      appBar: AppBar(title: Text("My Scrapbooks")),
      body: /*ElevatedButton(onPressed: (){print(CurrentUserScrapbookList.currentScrapbooks.length);}, child: Text('Test'))*/

      ListView.builder(
        itemCount: CurrentUserScrapbookList.currentScrapbooks.length,
        itemBuilder: (context, index){
          return ScrapbookTile(CurrentUserScrapbookList.currentScrapbooks[index]);
        },
      )
    );
  }
}
