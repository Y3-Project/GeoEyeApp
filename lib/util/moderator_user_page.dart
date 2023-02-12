import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../user_authentication_widgets/login_page.dart';
import 'package:flutter_app_firebase_login/util/moderator_util/moderator_util.dart';

import 'moderator_util/reported_comments_util.dart';

class ModeratorUserPage extends StatefulWidget {
  const ModeratorUserPage({Key? key});

  @override
  State<StatefulWidget> createState() => _moderatorUserState();
}

class _moderatorUserState extends State<ModeratorUserPage> {
  late StreamSubscription<QuerySnapshot> _querySnapshot;
  List<QueryDocumentSnapshot> _snapshots = List.empty(growable: true);
  List<Container> _display = List.empty(growable: true);

  @override
  void initState() {
    _querySnapshot = FirebaseFirestore.instance
        .collection("users")
        .snapshots()
        .listen((snapshot) {
      setState(() {
        _display.clear();
        _snapshots.clear();
        _snapshots.addAll(snapshot.docs);
        for (int i = 0; i < _snapshots.length; i++) {
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
    print("data: ${_snapshots[i].data().toString()}");
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

    return Scaffold(
      body: Text("To Be Completed..."),
      bottomSheet:
          ElevatedButton(child: Text("logout"), onPressed: () => logout()),
    );
  }
}
