import 'package:cloud_firestore/cloud_firestore.dart';

class Scrapbook {
  String id = '';
  String creatorid = '';
  String scrapbookTitle = '';
  String scrapbookThumbnail = '';
  String currentUsername = '';
  GeoPoint location = GeoPoint(0, 0);
  Timestamp timestamp = Timestamp.fromMillisecondsSinceEpoch(0);
  bool public = false; // scrapbooks are private by default

  /* Constructor */
  Scrapbook(
      {required this.id,
      required this.creatorid,
      required this.scrapbookTitle,
      required this.scrapbookThumbnail,
      required this.currentUsername,
      required this.location,
      required this.timestamp,
      required this.public});


  /* Convert a document to a Scrapbook object */
  Scrapbook.fromDocument(DocumentSnapshot doc) {
    this.id = doc.id;
    this.creatorid = doc['creatorid'].toString();
    this.scrapbookTitle = doc['scrapbookTitle'];
    this.scrapbookThumbnail = doc['scrapbookThumbnail'];
    this.currentUsername = doc['currentUsername'];
    this.location = doc['location'];
    this.timestamp = doc['timestamp'];
    this.public = doc['public'];
  }
}
