import 'dart:async';
import 'util/moderator_util/moderator_util.dart';
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
  List<Row> _display = List.empty(growable: true);

  @override
  void initState() {
    _querySnapshot = FirebaseFirestore.instance
        .collection("posts")
        .where("reported", isEqualTo: true)
        .snapshots()
        .listen((snapshot) {
      setState(() {
        _display.clear();
        _snapshots.clear();
        _snapshots.addAll(snapshot.docs);
      });
      for (int i = 0; i < _snapshots.length; i++) {
        print("index: " + i.toString());
        print("document id: " + _snapshots[i].id);
        initDisplay(i);
      }
    });
    super.initState();
  }

  Future<void> initDisplay(int i) async {
    print("data: " + _snapshots[i].data().toString());
    _display.add(await getPost(_snapshots[i]));
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

    print("_display length2: " + _display.length.toString());
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: const Text(
            "Moderator main page",
            style: TextStyle(fontSize: 25),
          )),
      body: _display != List.empty()
          ? ListView.builder(
              itemCount: _display.length,
              itemBuilder: ((context, index) {
                return Container(
                  child: Column(children: _display),
                );
              }))
          : Center(
              child: CircularProgressIndicator(
              color: Color.fromARGB(255, 2, 2, 2),
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
