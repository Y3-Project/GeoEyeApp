import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String content = ''; // the actual comment
  String post = '/posts/'; // the post which the comment is attached to
  List<dynamic> reports = List.empty(
      growable:
          true); // this is an array of refs to users who have reported the post
  String user = '/users/'; // the author of the comment
  Timestamp timestamp = Timestamp.fromMillisecondsSinceEpoch(0);
  String id = '/postComments/'; // document id

  /* Constructor */
  Comment(
      {required this.content,
      required this.post,
      required this.reports,
      required this.user,
      required this.timestamp,
      required this.id});

  /* Convert a document to a Comment object */
  Comment.fromDocument(DocumentSnapshot doc) {
    this.content = doc['content'];
    this.post = doc['post'].toString();
    this.reports = doc['reports'];
    this.user = doc['user'].toString();
    this.timestamp = doc['timestamp'];
    this.id = doc.id;
  }
}
