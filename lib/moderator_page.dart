import 'dart:async';

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
  late Stream<QuerySnapshot> data;

  @override
  void initState() {
    data = FirebaseFirestore.instance
        .collection("posts")
        .where("reported", isEqualTo: true)
        .snapshots();
    super.initState();
  }

  List<Row> getPosts(AsyncSnapshot<QuerySnapshot> snapshot) {
    List<Row> display = List.empty(growable: true);
    for (int i = 0; i < snapshot.data!.docs.length; i++) {
      display.add(Row(
        children: [
          Expanded(
            child: Text(
              // TODO: add conditions for text, picture, video
              snapshot.data!.docs[i].get("picture"),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                deletePost();
              },
              child: const Text("Delete"),
            ),
          )
        ],
      ));
    }
    return display;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> deletePost() async {
    //TODO: impl
    print("deleting happened");
  }

  @override
  Widget build(BuildContext context) {
    //method to log the user out
    Future<void> logout() async {
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
        title: const Text('Moderator Page', style: TextStyle(fontSize: 25)),
      ),
      bottomNavigationBar: BottomNavigationBar(items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings")
      ]),
      body: Center(
          child: StreamBuilder<QuerySnapshot>(
        stream: data,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Error fetching posts!");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading...");
          }

          if (snapshot.connectionState == ConnectionState.none) {
            return const Text("Error fetching reported posts!");
          }
          return Container(
            padding: const EdgeInsets.all(10),
            child: Column(children: getPosts(snapshot)),
          );
        },
      )),
      bottomSheet: ElevatedButton(
          onPressed: () {
            logout();
          },
          child: const Text('Logout')),
    );
  }
}
