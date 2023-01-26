import 'dart:async';
import 'package:flutter_app_firebase_login/main.dart';

import 'util/util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ModeratorPage extends StatefulWidget {
  final Function(User?) onSignOut;
  const ModeratorPage({required this.onSignOut});

  @override
  State<StatefulWidget> createState() => _ModeratorPageState();
}

class _ModeratorPageState extends State<ModeratorPage> {
  late StreamSubscription<QuerySnapshot> _querySnapshot;
  List<QueryDocumentSnapshot> _snapshots = List.empty(growable: true);
  late List<Row> _display;

  @override
  void initState() {
    super.initState();
    _querySnapshot = FirebaseFirestore.instance
        .collection("posts")
        .where("reported", isEqualTo: true)
        .snapshots()
        .listen((snapshot) {
      setState(() {
        _snapshots.addAll(snapshot.docs);
        for (int i = 0; i < _snapshots.length; ++i) {
          init(i);
        }
      });
    });
  }

  Future<void> init(index) async {
    _display = await getPosts(_snapshots[index]);
  }

  @override
  void dispose() {
    _querySnapshot.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //method to log the user out
    Future<void> _logout() async {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => LoginPage(onSignIn: (user) {}),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: const Text(
            "Moderator main page",
            style: TextStyle(fontSize: 25),
          )),
      body: _snapshots != null
          ? ListView.builder(
              itemCount: _snapshots.length,
              itemBuilder: ((context, index) {
                return Container(
                  child: Column(children: _display),
                );
              }))
          : Center(
              child: CircularProgressIndicator(
              color: Color.fromRGBO(0, 0, 0, 1),
            )),
      bottomSheet: ElevatedButton(
        onPressed: () {
          _logout();
        },
        child: Text("logout"),
      ),
    );
  }
}
