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
  List<QueryDocumentSnapshot> _snapshots = List.empty(growable: true);
  List<Container> _display = List.empty(growable: true);
  late StreamSubscription _stream; //stream for getting the current user's scarpbooks
  List<Scrapbook> _scrapbooks = List.empty(growable: true);


  Future<Container> makeContainer(Scrapbook scrapbook) async {
    return await Container(
      child: ScrapbookTile(scrapbook),
    );
  }

  Future<void> initDisplay(int i) async {
    print(_snapshots[i].data().toString());
    _display.add(await makeContainer(_scrapbooks[i]));
  }

  @override
  void initState() {
    String currentUsername = "";
    var inst = FirebaseFirestore.instance.collection("users")
    .where("uuid", isEqualTo: ProfilePage().getUuid().toString());
    inst.snapshots().listen((event) {
      for (var doc in event.docs) {
        currentUsername = doc.get("username");
      }
    });

    _stream = FirebaseFirestore.instance.collection("scrapbooks")
              .where("currentUsername", isEqualTo: currentUsername)
    .snapshots().listen((event) {
      setState(() {
        _display.clear();
        _snapshots.clear();
        _snapshots.addAll(event.docs);
        for (int i = 0; i < _snapshots.length; ++i) {
          _scrapbooks.add(Scrapbook.fromDocument(_snapshots[i]));
          initDisplay(i);
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("My Scrapbooks")),
      body:
      ListView.builder(
        itemCount: _display.length - _display.length + 1,
        itemBuilder: (context, index){
          return Container(child: Column(children: _display));
        },
      )
    );
  }
}
