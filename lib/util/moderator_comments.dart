import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_firebase_login/user_authentication_widgets/login_page.dart';
import 'package:flutter_app_firebase_login/util/moderator_util/reported_comments_util.dart';

class ModeratorCommentsPage extends StatefulWidget {
  const ModeratorCommentsPage({Key? key});

  @override
  State<StatefulWidget> createState() => _moderatorCommentsState();
}

class _moderatorCommentsState extends State<ModeratorCommentsPage> {
  late StreamSubscription<QuerySnapshot> _querySnapshot;
  List<QueryDocumentSnapshot> _snapshots = List.empty(growable: true);
  List<Container> _display = List.empty(growable: true);

  @override
  void initState() {
    _querySnapshot = FirebaseFirestore.instance
        .collection("postComments")
        .snapshots()
        .listen((snapshot) {
      setState(() {
        _display.clear();
        _snapshots.clear();
        _snapshots.addAll(snapshot.docs);
        for (int i = 0; i < _snapshots.length; i++) {
          // TODO: check that the "user" field actually leads to a path
          // TODO: check that the reported posts creator isn't timedout / banned,
          // as they've been checked already
          List<dynamic> reports = _snapshots[i].get("reports");
          if (reports.length == 0) {
            continue;
          }
          initDisplay(i);
        }
      });
    });
    super.initState();
  }

  Future<void> initDisplay(int i) async {
    print("comments: ${_snapshots[i].data().toString()}");
    _display.add(await getComment(_snapshots[i]));
  }

  @override
  void dispose() {
    _querySnapshot.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> logout() async {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => LoginPage(onSignIn: (user) {}),
        ),
      );
    }

    print("TOTAL REPORTED ITEMS TO DISPLAY (comments): ${_display.length}");
    return Scaffold(
      body: _display.length != 0
          ? ListView.builder(
              itemCount: _display.length - _display.length + 1,
              itemBuilder: ((context, index) {
                return Container(
                  child: Column(children: _display),
                );
              }))
          : Center(
              child: CircularProgressIndicator(
              color: Color.fromARGB(255, 2, 2, 2),
            )),
      bottomSheet:
          ElevatedButton(onPressed: () => logout(), child: Text("logout")),
    );
  }
}
