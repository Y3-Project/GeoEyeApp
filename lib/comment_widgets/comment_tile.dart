import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../util/comment.dart';

class CommentTile extends StatefulWidget {
  final Comment comment;

  CommentTile(this.comment);

  Comment getComment() {
    return this.comment;
  }

  @override
  State<StatefulWidget> createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  late StreamSubscription _stream;
  String _profilePicture = "";
  String _commenter = "";

  @override
  void initState() {
    // get the username
    _stream = FirebaseFirestore.instance
        .collection("users")
        .doc(this.widget.comment.user.id)
        .snapshots()
        .listen((event) {
      setState(() {
        _commenter = event.get("username");
        _profilePicture = event.get("profilePicture");
      });
    });
    super.initState();
  }

  Image getCommenterProfilePicture() {
    if (_profilePicture != "") {
      return Image.network(_profilePicture);
    } else {
      // default image file from images/default_image.png
      return Image.asset("images/default_avatar.png");
    }
  }

  CircleAvatar getAvatar() {
    return CircleAvatar(
      backgroundImage: getCommenterProfilePicture().image,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListTile(
          leading: getAvatar(),
          title: Text(this.widget.comment.content),
          subtitle: Text(_commenter),
        ),
      ),
    );
  }
}
