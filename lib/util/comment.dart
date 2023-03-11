import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String content = ''; // the actual comment
  String post = ''; // the post which the comment is attached to
  List<dynamic> reports = List.empty(
      growable:
          true); // this is an array of refs to users who have reported the post
  String user = ''; // the author of the comment
  Timestamp timestamp = Timestamp.fromMillisecondsSinceEpoch(0);

  /* Constructor */
  Comment(
      {required this.content,
      required this.post,
      required this.reports,
      required this.user,
      required this.timestamp});

  /* Convert a document to a Comment object */
  Comment.fromDocument(DocumentSnapshot doc) {
    this.content = doc['content'];
    this.post = doc['post'].toString();
    this.reports = doc['reports'];
    this.user = doc['user'].toString();
    this.timestamp = doc['timestamp'];
  }
}
