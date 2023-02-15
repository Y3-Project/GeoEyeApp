import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_firebase_login/util/moderator_util/moderator_util.dart';
import 'package:flutter_app_firebase_login/util/util.dart';

Future<Container> getComments(QueryDocumentSnapshot comment) async {
  return await getComment(comment);
}

Future<Container> getComment(QueryDocumentSnapshot comment) async {
  // TODO: rename function
  String userid = getUserDocumentIDFromPost(comment);
  String content = comment.get("content");
  var reports = comment.get("reports") as List<dynamic>;
  return await Container(
    child: Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Text(
                "Comment: ${comment.id}",
                softWrap: true,
              ),
              Text(
                "content: ${content}",
                softWrap: true,
              ),
              Text(
                "user: ${userid}",
                softWrap: true,
              ),
              Text(
                "reports: ${reports.length}",
                softWrap: true,
              )
            ],
          ),
        ),
        Expanded(
          child: createCommentDropDownMenu(comment, userid),
        )
      ],
    ),
    decoration:
        BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black))),
    padding: EdgeInsets.only(bottom: 10.0),
  );
}

PopupMenuButton createCommentDropDownMenu(
    QueryDocumentSnapshot comment, String user) {
  return PopupMenuButton(
      child: Text("Actions:"),
      itemBuilder: (context) => [
            PopupMenuItem(
                child: Text("delete"),
                value: 1,
                onTap: () {
                  deleteComment(comment);
                }),
            PopupMenuItem(
              child: Text("ban user ${user}"),
              value: 2,
              onTap: () {
                banUserFromComment(comment);
              },
            ),
            PopupMenuItem(
              child: Text("timeout user ${user}"),
              value: 3,
              onTap: () {
                timeoutUserFromComment(comment);
              },
            ),
            PopupMenuItem(
              child: Text("Allow comment (beta)${comment.id}"),
              value: 4,
              onTap: () {
                allowComment(comment);
              },
            )
          ]);
}

void allowComment(QueryDocumentSnapshot comment) {
  print("allow comment ${comment.id}, all reports will be removed");
  // TODO
  return;
}

void timeoutUserFromComment(QueryDocumentSnapshot comment) {
  print("timing out user ${comment.get("user")} from document: ${comment.id}");
  var date = DateTime.now();
  print("DATE: ${date.toString()},  ${date}}");
  // FIXME: similar to getUserDocumentPathFromPost
  String path = getUserDocumentPathFromComment(comment);
  DocumentReference user = FirebaseFirestore.instance.doc(path);
  user.update({"timeoutStart": date.toString()});
}

void banUserFromComment(QueryDocumentSnapshot comment) {
  print("banning user ${comment.get("user")} for comment ${comment.id}");
  // FIXME: similar to getUserDocumentPathFromPost
  String path = getUserDocumentPathFromComment(comment);
  DocumentReference user = FirebaseFirestore.instance.doc(path);
  user.update({'banned': true});
}

void deleteComment(QueryDocumentSnapshot comment) {
  print("DELETING COMMENT ${comment.id}");
  var inst = FirebaseFirestore.instance.collection('postComments');
  inst.doc("${comment.id}").delete();
}

String getUserDocumentPathFromComment(QueryDocumentSnapshot comment) {
  DocumentReference userDoc = comment.get("user");
  return userDoc.path;
}
