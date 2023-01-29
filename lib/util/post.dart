import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  Timestamp timestamp =
      Timestamp.fromMillisecondsSinceEpoch(0); // time the post was created
  GeoPoint location = GeoPoint(0, 0); // location of the post
  String picture =
      ''; // url to image eg 'https://firebasestorage.googleapis.com/v0/b/flutter-app-firebase-log-c1c41.appspot.com/o/images%2FKHkfKSUzbGhgmVPhIdHk%2FW9mNhinT7muurZpKLaUi%2Fpost.jpg?alt=media&token=61efd0ac-0788-4b12-9598-77e641115821'
  String video = ''; // url to video eg "
  String user = '/users/'; // path to author document eg '/users/abcdefg'
  String text = '';
  String id = '/posts/'; // document id
  int likes = 0; // do we want to keep track of which users liked the post?

  /* Constructor */
  Post(
      {required this.timestamp,
      required this.location,
      required this.picture,
      required this.video,
      required this.likes,
      required this.user,
      required this.text,
      required this.id});

  /* Convert a document to a Post object */
  Post.fromDocument(DocumentSnapshot doc) {
    this.timestamp = doc['timestamp'];
    this.location = doc['location'];
    this.picture = doc['picture'];
    this.video = doc['video'];
    this.likes = doc['likes'];
    this.user = doc['user'].toString();
    this.text = doc['text'];
    this.id = doc.id;
  }
}
