import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../util/GeoEyeNotification.dart';

class NotificationTile extends StatefulWidget {
  final GeoEyeNotification notification;

  NotificationTile(this.notification);

  GeoEyeNotification getNotification() {
    return this.notification;
  }

  @override
  State<StatefulWidget> createState() => _NotificationTileState();
}

class _NotificationTileState extends State<NotificationTile> {
  late StreamSubscription _stream;
  String _profilePicture = "";
  String _user = "";

  @override
  void initState() {
    // get the username
    _stream = FirebaseFirestore.instance
        .collection("users")
        .doc(this.widget.notification.user.id)
        .snapshots()
        .listen((event) {
      setState(() {
        _user = event.get("username");
        _profilePicture = event.get("profilePicture");
      });
    });
    super.initState();
  }

  Image getUserProfilePicture() {
    if (_profilePicture != "") {
      return Image.network(_profilePicture);
    } else {
      // default image file from images/default_image.png
      return Image.asset("images/default_avatar.png");
    }
  }

  CircleAvatar getAvatar() {
    return CircleAvatar(
      backgroundImage: getUserProfilePicture().image,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListTile(
          leading: getAvatar(),
          title: Text(_user + " commented on your post"),
          subtitle: Text(this.widget.notification.content),
        ),
      ),
    );
  }
}
