import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_firebase_login/scrapbook_widgets/scrapbook.dart';
import 'package:flutter_app_firebase_login/scrapbook_widgets/scrapbook_tile.dart';
import 'package:flutter_app_firebase_login/user_pages/main_page.dart';
import 'package:flutter_app_firebase_login/user_pages/post_pages/map_view_page.dart';

import '../user_pages/post_pages/popup_card_style.dart';

class MarkerScrapbook extends StatefulWidget {
  const MarkerScrapbook({Key? key}) : super(key: key);

  static Scrapbook markerScrapbook = Scrapbook(
      id: '',
      creatorid: '',
      scrapbookTitle: '',
      scrapbookThumbnail: '',
      currentUsername: '',
      location: GeoPoint(0.0, 0.0),
      timestamp: Timestamp.now(),
      public: false);

  @override
  State<MarkerScrapbook> createState() => _MarkerScrapbookState();
}

class _MarkerScrapbookState extends State<MarkerScrapbook> {
  late StreamSubscription _stream;

  @override
  void dispose() {
    _stream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String editedScrapbookRef = '';

    editedScrapbookRef = MarkerPopup.scrapbookReference;

    editedScrapbookRef = editedScrapbookRef.substring(51, 71);
    _stream = FirebaseFirestore.instance
        .collection("scrapbooks")
        .doc(editedScrapbookRef)
        .snapshots()
        .listen((event) {
      setState(() {
        MarkerScrapbook.markerScrapbook = Scrapbook.fromDocument(event);
      });
    });

    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        scrollable: true,
        content: ScrapbookTile(MarkerScrapbook.markerScrapbook),
        insetPadding: EdgeInsets.fromLTRB(20, 50, 20, 20),
      ),
      ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.white)),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => MainUserPage()),
            );
          },
          child: Text(
            'Back',
            style: TextStyle(color: Colors.black),
          ))
    ]);

    /*
    return ListView.builder(
      itemCount: 2,
      itemBuilder: (context, index){
        return ScrapbookTile(//the fetched scrapbook);
      },
    );
     */
  }
}
