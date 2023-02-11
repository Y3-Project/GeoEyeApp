import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Future<Container> getComments(QueryDocumentSnapshot comment) async {
  return await getComment(comment);
}

Future<Container> getComment(QueryDocumentSnapshot comment) async {
  String content = comment.get("content");
  return await Container(
    child: Row(
      children: [
        Expanded(child: Text("Text: ${content}")),
        Expanded(
          child: createCommentDropDownMenu(comment, comment.get("user")),
        )
      ],
    ),
  );
}

PopupMenuButton createCommentDropDownMenu(
    QueryDocumentSnapshot comment, String user) {
  return PopupMenuButton(
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
  print("DELETING COMMENT");
}

void timeoutUserFromComment(QueryDocumentSnapshot comment) {
  print("TIMEOUT USER FROM COMMENT");
}

void banUserFromComment(QueryDocumentSnapshot comment) {
  print("BAN USER FROM COMMENT");
}

void deleteComment(QueryDocumentSnapshot comment) {
  print("ALLOW COMMENT");
}
