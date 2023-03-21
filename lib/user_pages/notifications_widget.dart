import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../notification_widgets/notification_tile.dart';
import '../util/GeoEyeNotification.dart';

class NotificationsWidget extends StatefulWidget {
  const NotificationsWidget({Key? key}) : super(key: key);

  @override
  State<NotificationsWidget> createState() => _NotificationsWidgetState();
}

// WARNING THIS USES WAAY TOO MUCH BANDWIDTH AND SHOULD NOT BE LEFT OPEN
class _NotificationsWidgetState extends State<NotificationsWidget> {
  late StreamSubscription _querySnapshot;
  late StreamSubscription _querySnapshot2;
  late StreamSubscription _querySnapshot3;
  List<QueryDocumentSnapshot> _snapshots = List.empty(growable: true);
  List<QueryDocumentSnapshot> _snapshots2 = List.empty(growable: true);
  List<QueryDocumentSnapshot> _snapshots3 = List.empty(growable: true);
  List<NotificationTile> _displayNotifications = List.empty(growable: true);
  List<GeoEyeNotification> notifications = List.empty(growable: true);
  List<String> userPostIds = List.empty(growable: true);
  String currentUUID = "";
  List<DocumentReference> userDocument = List.empty(growable: true);
  List<String> ids = List.empty(growable: true);

  Future<void> initNotifications(int i) async {
    for (var id in ids) if (_snapshots[i].id == id) return;
    _displayNotifications
        .add(NotificationTile(GeoEyeNotification.fromComment(_snapshots[i])));
    ids.add(_snapshots[i].id);
  }

  Future<void> getCurrentUserReference() async {
    currentUUID = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection("users")
        .where("uuid", isEqualTo: currentUUID)
        .snapshots()
        .listen((event) {
      for (var doc in event.docs) {
        userDocument.add(doc.reference);
      }
    });
  }

  void addUserPostIds() {
    // loop through documents in the posts collections
    // add documents which have user matching current user
    _querySnapshot2 = FirebaseFirestore.instance
        .collection("posts")
        .snapshots()
        .listen((snapshot) {
      setState(() {
        _snapshots2.clear();
        _snapshots2.addAll(snapshot.docs);
        for (int i = 0; i < _snapshots2.length; i++) {
          if (_snapshots2[i].get("user") == userDocument[0]) {
            userPostIds.add(_snapshots2[i].id);
          }
        }
      });
    });
  }

  Future<void> loadNotifications() async {
    _querySnapshot = FirebaseFirestore.instance
        .collection("postComments")
        .snapshots()
        .listen((snapshot) {
      setState(() {
        _displayNotifications.clear();
        _snapshots.clear();
        _snapshots.addAll(snapshot.docs);
        for (int i = 0; i < _snapshots.length; i++) {
          List<dynamic> reports = _snapshots[i].get("reports");
          if (reports.length != 0) {
            // dont show a comment which has been reported
            continue;
          }

          _querySnapshot3 = FirebaseFirestore.instance
              .collection("posts")
              .snapshots()
              .listen((snapshot) {
            setState(() {
              _snapshots3.clear();
              _snapshots3.addAll(snapshot.docs);
              for (int k = 0; k < _snapshots3.length; k++) {
                // check if post belongs to current user
                // we do this by getting the post id of the comment from the db
                // and check if the list of posts which belong to the user includes this id
                if (_snapshots3[k].get("user") == userDocument[0]) {
                  print('here');
                  print(_snapshots3[k].get("user"));
                  initNotifications(i);
                } else {
                  print('there'); // WE SHOULD BE SEEING A WHOLE LOTTA THERES AND FEW HERES
                }
              }
            });
          });
        }
      });
    });
  }

  @override
  void initState() {
    getCurrentUserReference();
    addUserPostIds();
    loadNotifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 64,
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          "Notifications (" + _displayNotifications.length.toString() + ")",
          style: TextStyle(fontSize: 25),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var notificationTile in _displayNotifications)
              Container(
                height: 80,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => {
                      // todo: here we want to go to the profile of the user who triggered this notification
                    },
                    child: Container(
                        height: 50,
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: notificationTile)),
                  ),
                ),
              ),
          ],
        )),
      ),
    );
  }
}
