import 'package:cloud_firestore/cloud_firestore.dart';

class Scrapbook {
  String creatorid = '';
  GeoPoint location = GeoPoint(0, 0);
  Timestamp timestamp = Timestamp.fromMillisecondsSinceEpoch(0);

  /* Constructor */
  Scrapbook(
      {required this.creatorid,
      required this.location,
      required this.timestamp});

  /* Convert a document to a Scrapbook object */
  Scrapbook.fromDocument(DocumentSnapshot doc) {
    this.creatorid = doc['creatorid'];
    this.location = doc['location'];
    this.timestamp = doc['timestamp'];
  }
}
