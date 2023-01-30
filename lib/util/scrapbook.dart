import 'package:cloud_firestore/cloud_firestore.dart';

class Scrapbook {
  String creatorid = '';
  GeoPoint location = GeoPoint(0, 0);
  Timestamp timestamp = Timestamp.fromMillisecondsSinceEpoch(0);
  bool public = false; // scrapbooks are private by default

  /* Constructor */
  Scrapbook(
      {required this.creatorid,
      required this.location,
      required this.timestamp,
      required this.public});

  /* Convert a document to a Scrapbook object */
  Scrapbook.fromDocument(DocumentSnapshot doc) {
    this.creatorid = doc['creatorid'];
    this.location = doc['location'];
    this.timestamp = doc['timestamp'];
    this.public = doc['public'];
  }
}
