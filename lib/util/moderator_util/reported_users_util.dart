import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'moderator_util.dart';

Future<Container> getUser(QueryDocumentSnapshot snap) async {
  String id = snap.id;
  List<dynamic> reports = snap.get("reports");
  return Container(
    child: Row(
      children: [
        Expanded(
            child: Column(
          children: [
            Text(
              "user: ${id}",
              softWrap: true,
            ),
            Text(
              "number of reports: ${reports.length}",
              softWrap: true,
            )
          ],
        )),
        Expanded(child: createUserDropDownMenu(snap, id))
      ],
    ),
    decoration:
        BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black))),
    padding: EdgeInsets.only(bottom: 10.0),
  );
}

PopupMenuButton createUserDropDownMenu(snap, id) {
  return PopupMenuButton(
      child: Text("Actions:"),
      itemBuilder: (context) => [
            PopupMenuItem(
                child: Text("delete user ${id}"),
                value: 1,
                onTap: () {
                  deleteUser(snap);
                }),
            PopupMenuItem(
              child: Text("ban user ${id}"),
              value: 2,
              onTap: () {
                banUser(snap);
              },
            ),
            PopupMenuItem(
              child: Text("timeout user ${id}"),
              value: 3,
              onTap: () {
                timeoutUser(snap);
              },
            ),
            PopupMenuItem(
              child: Text("Allow user ${snap.id}"),
              value: 4,
              onTap: () {
                allowPostOrCommentOrUser(snap);
              },
            )
          ]);
}

Future<void> deleteUser(QueryDocumentSnapshot userDocument) async {
  print("DELETING USER ${userDocument.id}");
  var inst = FirebaseFirestore.instance.collection("users");
  inst.doc(userDocument.id).delete();
}

Future<void> banUser(QueryDocumentSnapshot user) async {
  FirebaseFirestore.instance.doc(user.reference.path).update({"banned": true});
}

Future<void> timeoutUser(QueryDocumentSnapshot user) async {
  FirebaseFirestore.instance
      .doc(user.reference.path)
      .update({"timeoutStart": Timestamp.now()});
}
