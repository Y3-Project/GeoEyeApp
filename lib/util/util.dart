import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_firebase_login/util/moderator_page.dart';
import 'package:geolocator/geolocator.dart';

int distanceFromOneGeoPointToAnotherInKM(GeoPoint p1, GeoPoint p2) {
  final _geoLocatorPlatform = GeolocatorPlatform.instance;
  final res = _geoLocatorPlatform.distanceBetween(
      p1.latitude, p1.longitude, p2.latitude, p2.longitude);
  return (res ~/ 1000);
}

/** getUserDocumentIDFromPost
 *
 * this gets a user document id from a post
 * note: a post has a reference to a user, so we can get that document and its id
 *
 */
String getUserDocumentIDFromPost(QueryDocumentSnapshot snap) {
  DocumentReference userDoc = snap.get("user");
  return userDoc.id;
}

String getUserDocumentPathFromPost(QueryDocumentSnapshot post) {
  DocumentReference userDoc = post.get("user");
  return userDoc.path;
}

String getUserDocumentFromUsername(String username) {
  String ref = "";
  FirebaseFirestore.instance
      .collection("users")
      .where("username", isEqualTo: username)
      .snapshots()
      .listen((event) {
    for (var document in event.docs) {
      ref = document.reference.path.toString();
    }
  });
  return ref;
}

bool timedOutUserOverLimit(String username, String timeoutStart) {
  if (timeoutStart == "") return false;
  DateTime start = DateTime.parse(timeoutStart);
  // check if 2 times are more than 24 hours apart, then that will return true
  return start.difference(DateTime.now()).inDays < 0 ? true : false;
}

Future<DocumentReference<Map<String, dynamic>>> getCurrentUserDocRef() {
  // Get the document reference of the current user
  // we do this by getting the uuid from FirebaseAuth and then looking up the Users collection for matching uuid
  Query<Map<String, dynamic>> q = FirebaseFirestore.instance
      .collection("users")
      .where("uuid", isEqualTo: FirebaseAuth.instance.currentUser!.uid);
  return q.get().then((value) => value.docs[0].reference);
}

/*
  @param: user: the user to be followed
  @param: newFollower: the user who is following the user

  @return: void

  todo: Return with various errors if we encounter issues
 */
void addFollower(String newFollower, String user) {
  // add follower to user's followers list
  FirebaseFirestore.instance.collection('users').doc(user).update({
    'followers': FieldValue.arrayUnion([newFollower])
  });

  // add following to new follower's following list
  FirebaseFirestore.instance.collection('users').doc(newFollower).update({
    'following': FieldValue.arrayUnion([user])
  });
}

/*
  @param: postID - the id of the post to add the comment to
  @param: comment - the comment to add to the post
  @param: commentAuthor - the user who is adding the comment

  @return: void
 */
void addComment(
    DocumentReference post, String comment, DocumentReference commentAuthor) {
  FirebaseFirestore.instance.collection('postComments').add({
    'content': comment,
    'post': post,
    'reports': [],
    'timestamp': DateTime.now(),
    'user': commentAuthor,
  });
}

/*
  @param: documentReference - the document reference of the user to get the username of
 */
String getUsername(DocumentReference documentReference) {
  String username = "";
  FirebaseFirestore.instance
      .doc(documentReference.path)
      .get()
      .then((value) => username = value.get("username"));
  return username;
}

/*
  @param: documentReference - the document reference of the post to be liked by the user
  note that here we assume that the logged in user is the user who is liking the post
 */
void likePost(DocumentReference post) {
  // add the user to the post's likes list
  FirebaseFirestore.instance.doc(post.path).update({
    "likes": FieldValue.arrayUnion([getCurrentUserDocRef()])
  });
}
