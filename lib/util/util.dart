import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
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

String getUserDocumentFromUsername(String username) {
  String ref = "";
  FirebaseFirestore.instance
      .collection("users")
      .where("username", isEqualTo: username)
      .snapshots()
      .listen((event) {
    for (var document in event.docs) {
      ref = document.reference.toString();
    }
  });
  return ref;
}

void createPostPicture(
    String title, String caption, String pictureURL, String username) {
  String user = getUserDocumentFromUsername(username);
  FirebaseFirestore.instance.collection("posts").add({
    "likes": [],
    "picture": pictureURL,
    "reports": [],
    "text": caption,
    "timestamp": FieldValue.serverTimestamp(),
    "title": title,
    "user": user, // this is a document reference as a string
    "video": ""
  });
}

void createPostVideo(
    String title, String caption, String videoURL, String username) {
  String user = getUserDocumentFromUsername(username);
  FieldValue.serverTimestamp();
  FirebaseFirestore.instance.collection("posts").add({
    "likes": [],
    "picture": "",
    "reports": [],
    "text": caption,
    "timestamp": DateTime.now(),
    "title": title,
    "user": user, // this is a document reference as a string
    "video": videoURL
  });
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
