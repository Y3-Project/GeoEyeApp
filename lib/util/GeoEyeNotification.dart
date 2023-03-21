import 'package:cloud_firestore/cloud_firestore.dart';

class GeoEyeNotification {
  String content = ''; // message of notification
  late DocumentReference post; // the post which the notification is related to
  late DocumentReference user; // user who triggered the notification
  Timestamp timestamp = Timestamp.fromMillisecondsSinceEpoch(0);

  /* Constructor */
  GeoEyeNotification({required this.content,
    required this.post,
    required this.user,
    required this.timestamp});

  // from comment document
  GeoEyeNotification.fromComment(DocumentSnapshot doc) {
    this.content = doc['content'];
    this.post = doc['post'];
    this.user = doc['user'];
    this.timestamp = doc['timestamp'];
  }

  // TODO: from post document (friend posted, liked)
}
