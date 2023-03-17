import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_firebase_login/scrapbook_widgets/scrapbook.dart';
import 'package:flutter_app_firebase_login/scrapbook_widgets/scrapbook_tile.dart';
import 'package:provider/provider.dart';
import '../user_pages/profile_page.dart';
import '../util/user_model.dart';

class CurrentUserScrapbookList extends StatefulWidget {
  const CurrentUserScrapbookList({Key? key}) : super(key: key);

  @override
  State<CurrentUserScrapbookList> createState() =>
      _CurrentUserScrapbookListState();
}

class _CurrentUserScrapbookListState extends State<CurrentUserScrapbookList> {
  List<QueryDocumentSnapshot> _snapshots = List.empty(growable: true);
  List<ScrapbookTile> _display = List.empty(growable: true);
  late StreamSubscription
      _stream; //stream for getting the current user's scarpbooks
  List<Scrapbook> _scrapbooks = List.empty(growable: true);

  Future<void> initDisplay(int i) async {
    print(_snapshots[i].data().toString());
    _display.add(ScrapbookTile(_scrapbooks[i]));
  }

  Future<void> getUsersScrapbooks(String username) async {
    FirebaseFirestore.instance
        .collection("scrapbooks")
        .where("currentUsername", isEqualTo: username)
        .snapshots()
        .listen((event) {
      setState(() {
        _display.clear();
        _snapshots.clear();
        _snapshots.addAll(event.docs);
        for (int i = 0; i < _snapshots.length; ++i) {
          print("here");
          _scrapbooks.add(Scrapbook.fromDocument(_snapshots[i]));
          initDisplay(i);
        }
      });
    });
  }

  @override
  void initState() {
    String? uuid = ProfilePage().getUuid();
    print(uuid);
    _stream = FirebaseFirestore.instance
        .collection("users")
        .where("uuid", isEqualTo: uuid)
        .snapshots()
        .listen((event) {
      for (var doc in event.docs) {
        getUsersScrapbooks(doc.get("username"));
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _stream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("My Scrapbooks")),
        body: _display.length != 0
            ? ListView.builder(
                itemCount: _display.length - _display.length + 1,
                itemBuilder: (context, index) {
                  return Container(child: Column(children: _display));
                },
              )
            : Center(
                child: Text(
                'You don\'t have any scrapbooks yet! \nGo to the Feed Page to add one.',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              )));
  }
}
